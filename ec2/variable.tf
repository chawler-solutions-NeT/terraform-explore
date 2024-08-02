variable "ami" {
    description = "The AMI ID of the Instance"
    type = string
    default = "ami-0c101f26f147fa7fd"
}

variable "instance_type" {
  description = "The size of the Instance"
  type = string
  default = "t2.micro"
}

variable "associate_public_ip" {
    description = "Associate public IP"
    type = bool
    default = true
}

variable "instance_profile" {
    description = "EC2 Instance profile"
    type = string
    default = "ec2Instanceprofile"
}

variable "ec2_market_type"{
    description = "EC2 Instance Market type"
    type = string
    default = "spot"
}

variable "block_size" {
    description = "EC2 block Size"
    type = number
    default = 10
}

variable "block_type" {
    description = "EC2 block type"
    type = string
    default = "gp3"
}

variable "ec2_apache" {
    description = "EC2 Instance name"
    type     = string
    default  = "apache-server"
}

variable "apache_sg" {
    description = "The security group for apache"
    type    = string
    default = "apache-sg"      
    }

variable "vpc_id" {
    description = "VPC ID for the network"
}

variable "vpc_cidr_block" {
    description = "CIDR block of the VPC ID"
}

variable "public_sub1" {
    description = "The public subnet from the VPC"
}

variable "key_name" {}

variable "environment" {
  description = "Name of the specific environment"
}

variable "instance_copy" {
    description = "Copy from EC2 instance"
}

# variable "instance_name" {
# type = list(string)
# default = ["apache-server-instance", "ansible-instance", "devops-instance"]
# }

variable "index_count" {
  description = "the number of instances"
}

variable "user_data" {
description = "scipt to be deployed on ansible"  
}
