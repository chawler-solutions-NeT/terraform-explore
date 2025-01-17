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