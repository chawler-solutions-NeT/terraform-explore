module "ec2_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.TF_key.key_name
    vpc_security_group_ids          = [aws_security_group.apache-server.id]
  environment = "sand"
  ami         = "ami-0eaf7c3456e7b5b68"
  #index_count = 4
  instance_copy = "jenkins-server-ami"
  #user_data     = file("${path.module}/project_inventory/ansible.sh")
  # source = 
  # destination = 
  # key_source = 
  # key_destination = 
  #depends_on = [ aws_ssm_parameter.jenkins_key, aws_ssm_parameter.jenkins_key ]

}

resource "aws_security_group" jenkins-server" {
  name        = jenkins-server-sg"
  description = "Allow inbound traffic and all outbound traffic to jenkins server"
  vpc_id      = aws_vpc.csnet_vpc.id
    ingress  {
    from_port = "8080"
    to_port   = "8085"
    protocol  = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

tags ={
    Name = jenkins-server-sg"  
}

}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.jenkins-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.jenkins-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.jenkins-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jenkins-server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



tags = {
    Name = "${var.environment}-${each.value}"
    Owner = "Devops",
    Environment = "${var.environment}"
    OS = "Linux"
  }

# Creating key-pair on AWS using SSH-jenkins key
 resource "aws_key_pair" "TF_key_1" {
   key_name   = "${var.environment}-TF_key_1"
   public_key =tls_public_key.rsa.public_key_openssh
  }

resource "tls_jenkins_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

##################################################
#Store in SSM Parameter
##################################################
resource "aws_ssm_parameter" "jenkins_key" {
  name  = "/${var.environment}/jenkins_key"
  type  = "SecureString"
  value = tls_jenkins_key.rsa.jenkins_key_pem
}

resource "aws_ssm_parameter" "jenkins_key" {
  name  = "/${var.environment}/jenkins_key"
  type  = "String"
  value = tls_jenkins_key.rsa.jenkins_key_openssh
}