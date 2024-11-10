#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo groupadd docker || true
sudo usermod -aG docker ec2-user
sudo systemctl restart docker
sleep 60
PUBLIC_KEY=$(aws ssm get-parameter --name /sand/public_key --with-decryption --query "Parameter.Value" --output text --region us-east-1)
echo $PUBLIC_KEY | sudo tee -a ~/.ssh/authorized_keys > /dev/null