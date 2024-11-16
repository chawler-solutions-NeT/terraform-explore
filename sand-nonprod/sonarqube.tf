module "sonarqube_module" {
  source                    = "../ec2"
  vpc_id                    = module.vpc_module.vpc_id
  vpc_cidr_block            = module.vpc_module.vpc_cidr_block
  public_sub1               = module.vpc_module.public_sub_1
  key_name                  = aws_key_pair.sonarqube.key_name
  vpc_security_group_ids    = [aws_security_group.sonarqube-server.id]
  environment               = "sand"
  ami                       = "ami-0eaf7c3456e7b5b68"
  index_count               = 1
  instance_copy             = "sonarqube-server-ami"
  user_data                 = templatefile("${path.module}/project_inventory/retrievePublicKey.tpl", {})
  instance_name             = "sonarqube"
  instance_type             = "t2.medium" 
  depends_on = [ aws_ssm_parameter.public_key, module.ansible_module ]

  tags = {
    Environment = "sand"
  }

}

######################################################
#Security Group
#####################################################
resource "aws_security_group" "sonarqube-server" {
  name        = "sonarqube-sg"
  description = "Allow inbound traffic and all outbound traffic to sonarqube Server"
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
    description      = "HTTP Port"
    from_port        = 8080
    to_port          = 8085
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    self              = true

  }

  tags = {
    Name = "${var.environment}-sonarqube-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_sonar" {
  security_group_id = aws_security_group.sonarqube-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http_sonar" {
  security_group_id = aws_security_group.sonarqube-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}



resource "aws_vpc_security_group_ingress_rule" "ssh_sonar" {
  security_group_id = aws_security_group.sonarqube-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_sonar" {
  security_group_id = aws_security_group.sonarqube-server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}
# Creating key-pair on AWS using SSH-sonarqube key
 resource "aws_key_pair" "sonarqube" {
   key_name   = "${var.environment}-sonarqube"
   public_key =tls_private_key.sonarqube_rsa.public_key_openssh
  }

resource "tls_private_key" "sonarqube_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

##################################################
#Store in SSM Parameter
##################################################
resource "aws_ssm_parameter" "sonarqube_private_key" {
  name  = "/${var.environment}/sonarqube_private_key"
  type  = "SecureString"
  value = tls_private_key.sonarqube_rsa.private_key_pem
}

resource "aws_ssm_parameter" "sonarqube_public_key" {
  name  = "/${var.environment}/sonarqube_public_key"
  type  = "String"
  value = tls_private_key.sonarqube_rsa.public_key_openssh
}