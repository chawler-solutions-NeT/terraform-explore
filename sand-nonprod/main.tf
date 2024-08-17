module "ansible_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.ansible_key.key_name
  environment = "sand"
  ami         = "ami-0eaf7c3456e7b5b68"
  vpc_security_group_ids = [aws_security_group.ansible-server.id]
  index_count = 1
  instance_copy = "ansible-server-ami"
  user_data     = file("${path.module}/project_inventory/ansible.sh")
  depends_on = [ aws_ssm_parameter.private_key, aws_ssm_parameter.public_key ]

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

# # Creating key-pair on AWS using SSH-public key
 resource "aws_key_pair" "ansible_key" {
   key_name   = "${var.environment}-ansible_key"
   public_key =tls_private_key.ansible_rsa.public_key_openssh

 }

resource "tls_private_key" "ansible_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

##################################################
#Store in SSM Parameter
##################################################
resource "aws_ssm_parameter" "private_key" {
  name  = "/${var.environment}/private_key"
  type  = "SecureString"
  value = tls_private_key.ansible_rsa.private_key_pem
}

resource "aws_ssm_parameter" "public_key" {
  name  = "/${var.environment}/public_key"
  type  = "String"
  value = tls_private_key.ansible_rsa.public_key_openssh
}

#################################################
#Ansible security Group
#################################################

resource "aws_security_group" "ansible-server" {
  name        = "ansible-sg"
  description = "Allow inbound traffic and all outbound traffic to ansible Server"
  vpc_id      = module.vpc_module.vpc_id

  ingress {
    description      = "ssh port"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [module.vpc_module.vpc_cidr_block]
    self              = true

  }

  ingress {
    description      = "Tomcat Port"
    from_port        = 8080
    to_port          = 8085
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    # self              = true

  }

  tags = {
    Name = "${var.environment}-ansible-sg"
  }
}



resource "aws_vpc_security_group_ingress_rule" "allow_https_ansible" {
  security_group_id = aws_security_group.ansible-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http_ansible" {
  security_group_id = aws_security_group.ansible-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}



resource "aws_vpc_security_group_ingress_rule" "ssh_ansible" {
  security_group_id = aws_security_group.ansible-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_ansible" {
  security_group_id = aws_security_group.ansible-server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}