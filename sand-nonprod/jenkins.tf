module "jenkins_module" {
  source                    = "../ec2"
  vpc_id                    = module.vpc_module.vpc_id
  vpc_cidr_block            = module.vpc_module.vpc_cidr_block
  public_sub1               = module.vpc_module.public_sub_1
  key_name                  = aws_key_pair.jenkins.key_name
  vpc_security_group_ids    = [aws_security_group.jenkins-server.id]
  environment               = "sand"
  ami                       = "ami-0eaf7c3456e7b5b68"
  index_count               = 1
  instance_copy             = "jenkins-server-ami"
  user_data                 = null
  instance_name             = "jenkins"
  #depends_on = [ aws_ssm_parameter.jenkins_key, aws_ssm_parameter.jenkins_key ]


  tags = {
    Environment = "sand"
  }

}

######################################################
#Security Group
#####################################################
resource "aws_security_group" "jenkins-server" {
  name        = "jenkins-sg"
  description = "Allow inbound traffic and all outbound traffic to jenkins Server"
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
    Name = "${var.environment}-jenkins-sg"
  }
}



resource "aws_vpc_security_group_ingress_rule" "allow_https_jenkins" {
  security_group_id = aws_security_group.jenkins-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http_jenkins" {
  security_group_id = aws_security_group.jenkins-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}



resource "aws_vpc_security_group_ingress_rule" "ssh_jenkins" {
  security_group_id = aws_security_group.jenkins-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_jenkins" {
  security_group_id = aws_security_group.jenkins-server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}
# Creating key-pair on AWS using SSH-jenkins key
 resource "aws_key_pair" "jenkins" {
   key_name   = "${var.environment}-jenkins"
   public_key =tls_private_key.jenkins_rsa.public_key_openssh
  }

resource "tls_private_key" "jenkins_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

##################################################
#Store in SSM Parameter
##################################################
resource "aws_ssm_parameter" "jenkins_private_key" {
  name  = "/${var.environment}/jenkins_private_key"
  type  = "SecureString"
  value = tls_private_key.jenkins_rsa.private_key_pem
}

resource "aws_ssm_parameter" "jenkins_public_key" {
  name  = "/${var.environment}/jenkins_public_key"
  type  = "String"
  value = tls_private_key.jenkins_rsa.public_key_openssh
}