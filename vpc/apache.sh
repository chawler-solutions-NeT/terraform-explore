#!/bin/bash
sudo yum update && sudo yum upgrade -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd 
sudo mv /home/ec2-user/index.html /var/www/html/index.html










 










