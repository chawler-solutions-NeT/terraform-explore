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
sudo sed -i 's/#private_key_file = \/path\/to\/file/private_key_file = \/home\/ec2-user\/.ssh\/private_key.pem/g' /etc/ansible/ansible.cfg
sudo sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg
(crontab -l; echo "* * * * * /usr/bin/python3 /tmp/class26/inventory.py") | crontab -
sleep 120
# Try to fetch the PRIVATE key from SSM and add it to authorized_keys
for i in {1..5}; do
    PRIVATE_KEY=$(aws ssm get-parameter --name /$environment/private_key --with-decryption --query "Parameter.Value" --output text --region us-east-1 2>/dev/null)
    if [ -n "$PRIVATE_KEY" ]; then
        echo "$PRIVATE_KEY" | sudo tee -a /home/ec2-user/.ssh/private_key.pem > /dev/null
        sudo chmod 600 /home/ec2-user/.ssh/private_key.pem
        echo "PRIVATE key added successfully to authorized_keys."
        break
    else
        echo "Attempt $i: Failed to retrieve PRIVATE key"
        sleep 30
    fi
done

if [ -z "$PRIVATE_KEY" ]; then
    echo "Failed to retrieve PRIVATE key"
fi
