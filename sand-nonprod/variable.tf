variable "domain_name" {
  description = "Domain name of choice"
  type = string
  default = "sammybisnuel.net"
}

variable "overwrite_option" {
description = "boolean to allow overwrite"
default = true
}

variable "time_to_live" {
  description = "Time to live"
  type = number
  default = 60
}

variable "environment" {
  description = "Name of the specific environment"
  default = "sand"
}

variable "key_count" {
  default = 3
}

# variable "user_data" {
# description = "scipt to be deployed on ansible"  
# }
#########################################
variable "manager_count" {
  default = 1
}

variable "worker_count" {
  default = 2
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = "ami-0eaf7c3456e7b5b68"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "ec2_market_type"{
    description = "EC2 Instance Market type"
    type = string
    default = "spot"
}

variable "aws_region" {
  default = "us-east-1"
}