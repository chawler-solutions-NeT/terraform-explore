#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo usermod -aG docker ec2-user
sudo service docker start
sudo service docker enable
sudo service restart docker


ADVERTISE_ADDR=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
# Initialize Swarm
if [ ! -f /tmp/initialized ]; then
  docker swarm init --advertise-addr $ADVERTISE_ADDR
  MANAGER_TOKEN=$(docker swarm join-token manager -q)
  aws ssm put-parameter --name "/swarm/manager/token" --value "$MANAGER_TOKEN" --type String --overwrite --region ${var.aws_region}
  TOKEN=$(docker swarm join-token -q worker)
  aws ssm put-parameter --name /docker-swarm/worker_token --value $TOKEN --type SecureString --overwrite
  touch /tmp/initialized
else
  TOKEN=$(aws ssm get-parameter --name /docker-swarm/worker_token --with-decryption --query "Parameter.Value" --output text)
  docker swarm join --token $TOKEN $(aws ssm get-parameter --name /docker-swarm/manager_ip --with-decryption --query "Parameter.Value" --output text):2377
fi

# Store manager IP
aws ssm put-parameter --name /docker-swarm/manager_ip --value $(hostname -i) --type String --overwrite
