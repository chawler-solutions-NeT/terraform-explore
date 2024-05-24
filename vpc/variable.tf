## this block create variable for cidr
variable "vpc_cidr" {
  description = "the ipv4 cidr for vpc"
  type        = string
  default     = "10.0.#0.0/16"
}

#
## this block create instance tenancy
variable "instance_tenancy" {
  description = "instance tenancy for vpc"
  type        = string
  default     = "default"
}


##this block create vpc tag
variable "csnet-terraform-demo-vpc" {
    description = "vpc name"
    type     = string
    default  = "csnet-vpc"
}

##the block create public sub 1
variable "public_sub_1_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = string
  default     = "10.100.1.0/24"
}

##this block create availabity zone for pub sub 1
variable "us-east-1a" {
  description = "availability zone for us east 1"
  type = string
  default = "us-east-1a"
}

##this block create tag for pub sub 1
variable "public-sub-1" {
    description = "pub sub 1 tag"
    type     = string
    default  = "public-sub-1"
}

##the block create public sub 2
variable "public_sub_2_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = string
  default     = "10.100.2.0/24"
}

##this block create tag for pub sub 2
variable "public-sub-2" {
    description = "pub sub 2 tag"
    type     = string
    default  = "public-sub-2"
}

##the block create private sub 1
variable "private_sub_1_cidr" {
  description = "A list of private subnets inside the VPC"
  type        = string
  default     = "10.100.3.0/24"
}

##this block create availabity zone for pub sub 2
variable "us-east-1b" {
  description = "availability zone for us east 1 b"
  type = string
  default = "us-east-1b"
}

##this block create tag for private sub 1
variable "private-sub-1" {
    description = "pri sub 1 tag"
    type     = string
    default  = "private-sub-1"
}

##the block create private sub 2
variable "private_sub_2_cidr" {
  description = "A list of private subnets inside the VPC"
  type        = string
  default     = "10.100.4.0/24"
}

##this block create tag for private sub 2
variable "private-sub-2" {
    description = "pri sub 2 tag"
    type     = string
    default  = "private-sub-2"
}

##the block create private rtb
variable "priv_rtb_cidr" {
  description = "A list of private rtb inside the VPC"
  type        = string
  default     = "0.0.0.0/0"
}

#this block create tag for private rtb
variable "private_rtb" {
    description = "pri rtb tag"
    type     = string
    default  = "private-rtb"
}

##the block create public rtb
variable "pub_rtb_cidr" {
  description = "A list of public rtb inside the VPC"
  type        = string
  default     = "0.0.0.0/0"
}

#this block create tag for pub rtb
variable "public_rtb" {
    description = "pub rtb tag"
    type     = string
    default  = "public-rtb"
}

#this block create tag for igw
variable "csnet-igw" {
    description = "tag for vpc igw"
    type     = string
    default  = "csnet-igw"
}

##this block create eip for vpc
variable "csnet_eip" {
  description = "eip for csnet vpc"
  type        =string
  default     ="vpc"
}

#this block create tag for eip
variable "csnet-eip" {
    description = "tag for vpc eip"
    type     = string
    default  = "csnet-eip"
}

#this block create tag for vpc ngw
variable "csnet-NAT" {
    description = "tag for vpc ngw"
    type     = string
    default  = "csnet-NAT"
}








  
  
  
  
  
  

