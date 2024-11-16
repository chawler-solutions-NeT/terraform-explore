#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sleep 120
# Try to fetch the PUBLIC key from SSM and add it to authorized_keys
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