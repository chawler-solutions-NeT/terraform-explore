##this block create name for LT
variable "name" {
 description = "name for apache launch templ"
 type   =   string
 default = "apache-lt"        
}

##this block create ec2 instance profile for LT
variable "instance_profile" {
    description = "EC2 Instance profile"
    type = string
    default = "ec2Instanceprofile"
}

##this block create volume size for LT
variable "volume_size" {
    description = "lauch template volume size"
    type = number
    default = 10
}

##this block create instance market option for LT
variable "instance-market_option"{
    description = "launch temp instance market option"
    type = string
    default = "spot"
}

##this block create size of instance type for LT
variable "instance_type" {
  description = "The size of launch temp instance type"
  type = string
  default = "t2.medium"
}

##this block create http endpoint for LT
variable "http_endpoint" {
  description = "endpoint for launch temp"
  type = string
  default = "enabled"
}

##this block create http token for LT
variable "http_tokens" {
  description = "http tokens for launch temp"
  type = string
  default = "required"
}

##this block create http response hop limit
variable "http_put_response_hop_limit" {
  description = "response hop limit for launch temp"
  type = number
  default = 1
}

##this block create instance metadata tags
variable "instance_metadata-tags" {
  description = "instance metadata tag on launch templ"
  type = string
  default = "enabled"
}

##this block create monitoring for launch temp
variable "enabled" {
  description = "monitoring of launch templ"
  type = bool
  default = false
}

##this block create associate public ip address for LT 
variable "associate_public_ip_address" {
  description = "associate public ip address for launch templ"
  type = bool
  default = true
}

##this block create launch temp resource type
variable "resource_type" {
  description = "resource type for launch templ"
  type = string
  default = "instance"
}

variable "image_id" {
  description = "Launch template AMI"
}

variable "subnet_id" {
  description = "vpc subnet 1"
}

variable "security_groups" {
  description = "security groups id"
}

variable "key_pair" {
  description = "value of the keypair attached to the Instance"
}

variable "environment" {
  description = "Name of the specific environment"
}