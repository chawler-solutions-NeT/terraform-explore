# boolean - condition for true or false
# String - combination of alphanumeric characters deliminated with a double quote ""
#Set of strings -  a group of strings deliminated with
# square brackets []
#provisioner: file, remote-exec, local-exec (requires connection block)

resource "aws_instance" "apache-server" {
  //count = length(local.instance_names)
  for_each                        = local.instance_names
  ami                             = var.ami
  instance_type                   = var.instance_type
  key_name                        = var.key_name    //this is assumed that you have already created/uploaded you keypair to aws keypair
  vpc_security_group_ids          = [aws_security_group.apache-server[each.key].id]
  associate_public_ip_address     = var.associate_public_ip
  subnet_id                       = var.public_sub1
  iam_instance_profile            = var.instance_profile
  user_data                       = var.user_data
  instance_market_options {
    spot_options {
      max_price = 0.0400
    }
    market_type = var.ec2_market_type
  }
    ebs_block_device {
        device_name = "/dev/sdf"
        delete_on_termination = true
        volume_size = var.block_size
        volume_type = var.block_type
    }
    root_block_device {
        delete_on_termination = true
        volume_size = var.block_size
        volume_type = var.block_type
    }
  tags = {
    Name = "${var.environment}-${each.value}"
    Owner = "Devops",
    Environment = "${var.environment}"
    OS = "Linux"
}


    ##Name = "${var.environment}-${var.ec2_apache}" // dev-apache-server
 
  }


############Creates a copy of the Instance AMI
# resource "aws_ami_from_instance" "apache_copy" {
#   count = 3
#   name               = var.instance_copy
#   source_instance_id = aws_instance.apache-server.id
#   snapshot_without_reboot = true

#   tags = {
#     Name = "${var.environment}-apache-server-ami" // sand-apache-server-ami
#   }
# }

resource "aws_security_group" "apache-server" {
  //count = length(local.instance_names)
  for_each    = local.instance_names
  name        = "${each.value}-sg"
  description = "Allow inbound traffic and all outbound traffic to Apache Server"
  vpc_id      = var.vpc_id

  ingress {
    description      = "ssh port"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpc_cidr_block]
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
    Name = "${var.environment}-${each.value}-sg"
  }
}



resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  for_each          = aws_security_group.apache-server
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each          = aws_security_group.apache-server
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}



resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each    = aws_security_group.apache-server
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  for_each    = aws_security_group.apache-server
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}