#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo amazon-linux-extras install ansible2 -y
sudo yum install python3-pip -y
pip3 install boto3
sudo mkdir -p /tmp/class26
sudo chmod 700 /tmp/class26
sudo chown ec2-user:ec2-user /tmp/class26
aws s3 cp s3://ansible-build-bucket/project_inventory/inventory.py /tmp/class26/inventory.py
sudo sed -i 's/#private_key_file = \/path\/to\/file/private_key_file = \/home\/ec2-user\/.ssh\/.pem/g' /etc/ansible/ansible.cfg
sudo sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg
(crontab -l; echo "* * * * * /usr/bin/python3 /tmp/class26/inventory.py") | crontab -
aws ssm get-parameter --region us-east-1 --name "/${var.environment}/private_key_0" --with-decryption --query "Parameter.Value" --output text > ~/.ssh/private_key.pem
sudo chown ec2-user:ec2-user ~/.ssh/private_key.pem
sudo chmod 600 ~/.ssh/private_key.pem