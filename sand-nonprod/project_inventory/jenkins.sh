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