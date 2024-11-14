#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
#sudo yum install java-1.8.0-openjdk-devel -y #-----------> use this is for Amazon linux 2 down
sudo yum install java-17-amazon-corretto -y
sudo yum install git -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sleep 120
# Try to fetch the public key from SSM and add it to authorized_keys
PUBLIC_KEY=$(aws ssm get-parameter --name /sand/public_key --with-decryption --query "Parameter.Value" --output text --region us-east-1)
if [ -n "$PUBLIC_KEY" ]; then
    echo "$PUBLIC_KEY" | sudo tee -a /home/ec2-user/.ssh/authorized_keys > /dev/null
    echo "Public key added successfully to authorized_keys."
else
    echo "Failed to retrieve public key from SSM. Check the SSM parameter and instance permissions."
fi