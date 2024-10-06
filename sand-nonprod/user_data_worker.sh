#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo usermod -aG docker ec2-user
sudo service docker start
sudo service docker enable
sudo service restart docker
TOKEN=$(aws ssm get-parameter --name /docker-swarm/worker_token --with-decryption --query "Parameter.Value" --output text)
MANAGER_IP=$(aws ssm get-parameter --name /docker-swarm/manager_ip --with-decryption --query "Parameter.Value" --output text)
docker swarm join --token $TOKEN ${MANAGER_IP}:2377
