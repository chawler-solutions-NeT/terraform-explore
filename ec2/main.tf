# boolean - condition for true or false
# String - combination of alphanumeric characters deliminated with a double quote ""
#Set of strings -  a group of strings deliminated with square brackets []
#provisioner: file, remote-exec, local-exec (requires connection block)

resource "aws_instance" "apache-server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      =  aws_key_pair.bash.key_name    //this is assumed that you have already created/uploaded you keypair to aws keypair
  vpc_security_group_ids = [aws_security_group.apache-server.id]
  associate_public_ip_address = var.associate_public_ip
  subnet_id         = aws_subnet.public_sub_1.id
  iam_instance_profile = var.instance_profile
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
    Name = var.ec2_apache
  }




  #Use file provisioner to copy index.html to /var/www/html
  #  provisioner "file" {
  #   source = "${path.module}/index_files/index.html"
  #   destination = "/home/ec2-user/index.html"
  # }

  provisioner "remote-exec" {
    script = "./tomcat.sh"
    # inline = [
    #     "sudo yum update -y",
    #     "sudo yum install httpd -y",
    #     "sudo cp /home/ec2-user/index.html /var/www/html/index.html",
    #     "sudo systemctl start httpd",
    #     "sudo systemctl enable httpd",       
    # ]
  }


   #connection block is required for provisioner to work
  connection {
    type   = "ssh"
    user   = "ec2-user"
    private_key = file("~/keypair/devops")
    host      = self.public_ip
  }

}


############Creates a copy of the Instance AMI
resource "aws_ami_from_instance" "apache_copy" {
  name               = "apache-server-ami"
  source_instance_id = aws_instance.apache-server.id
  snapshot_without_reboot = true

  tags = {
    Name = "apache-server-ami"
  }
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "bash" {
  key_name   = "bash"
  public_key = file("~/keypair/devops.pub")
}


resource "aws_security_group" "apache-server" {
  name        = "apache-server-sg"
  description = "Allow inbound traffic and all outbound traffic to Apache Server"
  vpc_id      = aws_vpc.csnet_vpc.id

  ingress {
    description      = "ssh port"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.csnet_vpc.cidr_block]
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
    Name = "apache-server-sg"
  }
}



resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.apache-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.apache-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}



resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.apache-server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.apache-server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}



