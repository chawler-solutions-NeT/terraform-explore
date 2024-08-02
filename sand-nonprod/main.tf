module "ec2_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.TF_key[0].key_name
  environment = "sand"
  ami         = "ami-0eaf7c3456e7b5b68"
  index_count = 3
  instance_copy = "apache-server-ami"
  user_data     = file("inventory.py")


connection {
type = "ssh"
user = "ec2-user"
private_key = file("~/Demo/pager")
host = aws_instance.ansible-server[0].public_ip
}


provisioner "file" {
source	= "${path.module}/project_inventory/inventory.py"            
destination	= "/var/tmp/.ssh/inventory.py"
}


provisioner "file" {
source	= "${path.module}/TF_key            
destination	= "/var/tmp/.ssh/TF_key
}

#using remote-exec to run scripts on my ec2 instance

provisioner "remote-exec" {
 script = "${path.module}/inventory.py"
inline  = [
                #!/bin/bash
                sudo apt update
                sudo apt upgrade -y
                sudo apt install ansible -y
                sudo apt install python3-pip -y
                pip3 install boto3
                sudo mkdir -p /var/tmp/class26
                sudo sed -i s/private_key_file = \/path\/to\/file/private_key_file = \/path\/to\/private_key/g' /etc/ansible/ansible.cfg
                sudo sed -i s/host_key_checking = False/host_key_checking = True/g' /etc/ansible/ansible.cfg
                (crontab -l , echo "* * * * * /usr/bin/python3 /tmp/class26/auto_inventory_script.py") | crontab -
                aws ssm get-parameter --name "private-key" --with-decryption --query "Parameter.Value" --output text > /var/tmp/.ssh/private_key.pem
                sudo chown ec2-user:ec2-user ~/.ssh/private_key.pem
                sudo chmod 600 ~/.ssh/private_key.pem
]
}

}

module "vpc_module" {
  source = "../vpc"
  environment = "sand"
  vpc_cidr = "10.120.0.0/16"
  public_sub_1_cidr = "10.120.1.0/24"
  public_sub_2_cidr = "10.120.2.0/24"
  private_sub_1_cidr = "10.120.3.0/24"
  private_sub_2_cidr = "10.120.4.0/24"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "TF_key" {
  key_name   = "${var.environment}-TF_key-${count.index}"
  public_key =tls_private_key.rsa[0].public_key_openssh
  count = var.key_count
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
  count = var.key_count
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa[0].private_key_pem
  filename = "${var.environment}-tfkey"
  count = var.key_count
}
