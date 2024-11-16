data "template_file" "worker_userdata" {
  template = <<EOF
#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Install Docker and start the service
sudo yum update -y
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo groupadd docker || true
sudo usermod -aG docker ec2-user
sudo systemctl restart docker
sleep 120
# Try to fetch the public key from SSM and add it to authorized_keys
for i in {1..5}; do
    PUBLIC_KEY=$(aws ssm get-parameter --name /sand/public_key --with-decryption --query "Parameter.Value" --output text --region us-east-1 2>/dev/null)
    if [ -n "$PUBLIC_KEY" ]; then
        echo "$PUBLIC_KEY" | sudo tee -a /home/ec2-user/.ssh/authorized_keys > /dev/null
        echo "Public key added successfully to authorized_keys."
        break
    else
        echo "Attempt $i: Failed to retrieve public key"
        sleep 30
    fi
done

if [ -z "$PUBLIC_KEY" ]; then
    echo "Failed to retrieve public key"
fi

# Fetch the Swarm Worker Token and Manager IP from SSM
SWARM_WORKER_TOKEN=$(aws ssm get-parameter --name "/swarm/worker/token" --with-decryption --query "Parameter.Value" --output text --region ${var.aws_region} || echo "")
SWARM_MANAGER_IP=$(aws ssm get-parameter --name "/swarm/manager/ip" --query "Parameter.Value" --output text --region ${var.aws_region} || echo "")

# Ensure both SWARM_WORKER_TOKEN and SWARM_MANAGER_IP are not empty
if [ -z "$SWARM_WORKER_TOKEN" ] || [ -z "$SWARM_MANAGER_IP" ]; then
  echo "Error: Missing Swarm worker token or manager IP." >> /var/log/swarm-worker-init.log
  exit 1
fi

# Join the Docker Swarm as a worker
docker swarm join --token "$SWARM_WORKER_TOKEN" "$SWARM_MANAGER_IP:2377" >> /var/log/swarm-worker-init.log 2>&1

if [ $? -eq 0 ]; then
  echo "Successfully joined the Docker Swarm as a worker." >> /var/log/swarm-worker-init.log
else
  echo "Failed to join the Docker Swarm as a worker." >> /var/log/swarm-worker-init.log
  exit 1
fi
EOF
}
