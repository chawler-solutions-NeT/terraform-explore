variable "domain_name" {
  description = "Domain name of choice"
  type = string
  default = "sammybisnuel.net"
}

variable "private_zone" {
  description = "Select the zone public/private"
  type = bool
  default = false
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


variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "manager_instance_type" {
  description = "EC2 instance type for manager nodes"
  default     = "t2.micro"
}

variable "worker_instance_type" {
  description = "EC2 instance type for worker nodes"
  default     = "t2.micro"
}

variable "desired_managers" {
  description = "Desired number of manager nodes"
  default     = 3
}

variable "desired_workers" {
  description = "Desired number of worker nodes"
  default     = 6
}

variable "ami_id" {
  default = "ami-00f251754ac5da7f0"
  description = "AMI ID for EC2 instances"
}
