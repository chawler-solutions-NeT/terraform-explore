#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
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