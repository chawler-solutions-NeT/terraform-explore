data "template_file" "manager_userdata" {
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
PUBLIC_KEY=$(aws ssm get-parameter --name /sand/public_key --with-decryption --query "Parameter.Value" --output text --region us-east-1)
if [ -n "$PUBLIC_KEY" ]; then
    echo "$PUBLIC_KEY" | sudo tee -a /home/ec2-user/.ssh/authorized_keys > /dev/null
    echo "Public key added successfully to authorized_keys."
else
    echo "Failed to retrieve public key from SSM. Check the SSM parameter and instance permissions."
fi

# Fetch the local IP address
ADVERTISE_ADDR=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Retrieve the Swarm Manager Token and Manager IP from SSM
SWARM_MANAGER_TOKEN=$(aws ssm get-parameter --name "/swarm/manager/token" --with-decryption --query "Parameter.Value" --output text --region ${var.aws_region} || echo "")
SWARM_MANAGER_IP=$(aws ssm get-parameter --name "/swarm/manager/ip" --query "Parameter.Value" --output text --region ${var.aws_region} || echo "")

# Check if the node is already a manager
if ! docker node ls &>/dev/null; then
  if [ -z "$SWARM_MANAGER_TOKEN" ]; then
    # Initialize Swarm if no manager token exists
    docker swarm init --advertise-addr "$ADVERTISE_ADDR"

    # Save the new manager token to SSM
    MANAGER_TOKEN=$(docker swarm join-token manager -q)
    aws ssm put-parameter --name "/swarm/manager/token" --value "$MANAGER_TOKEN" --type String --overwrite --region ${var.aws_region}

    # Save the new worker token to SSM
    WORKER_TOKEN=$(docker swarm join-token worker -q)
    aws ssm put-parameter --name "/swarm/worker/token" --value "$WORKER_TOKEN" --type String --overwrite --region ${var.aws_region}

    # Save the manager IP to SSM
    aws ssm put-parameter --name "/swarm/manager/ip" --value "$ADVERTISE_ADDR" --type String --overwrite --region ${var.aws_region}
  else
    # Join the existing Swarm using the retrieved token and manager IP
    docker swarm join --token "$SWARM_MANAGER_TOKEN" --advertise-addr "$ADVERTISE_ADDR" "$SWARM_MANAGER_IP:2377"
  fi
else
  echo "Node is already a Docker Swarm manager."
fi
EOF
}
