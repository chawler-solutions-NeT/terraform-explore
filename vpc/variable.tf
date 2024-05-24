##Block creates cidr block
variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

##Block creates instance tenancy
variable "instance_tenancy" {
  description = "instance tenency for our VPC"
  type        = string
  default     = "default"
}

#Block create tag for vpc
variable "csnet-terraform-demo-vpc" {
    description = "our vpc name"
    type     = string
    default  = "csnet-vpc"
}

##Block creates public sub1
variable "public_sub_1_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = string
  default     = "10.100.1.0/24"
}

##Block creates availability zone for pub sub1
variable "us-east-1a" {
  description = "availabilty zone for pub sub 1"
  type = string
  default = "us-east-1a"
}


#Block create tag for pub sub1
variable "public-sub-1" {
    description = "public sub 1 tag"
    type     = string
    default  = "public-sub-1"
}


##Block creates public sub2
variable "public_sub_2_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = string
  default     = "10.100.2.0/24"
}


##Block creates availability zone for pub sub2
variable "us-east-1b" {
  description = "availabilty zone for pub sub 2"
  type = string
  default = "us-east-1b"
}


#Block create tag for pub sub2
variable "public-sub-2" {
    description = "public sub 2 tag"
    type     = string
    default  = "public-sub-2"
}


##Block creates private sub1
variable "private_sub_1_cidr" {
  description = "A list of private subnets inside the VPC"
  type        = string
  default     = "10.100.3.0/24"
}


#Block create tag for private sub1
variable "private-sub-1" {
    description = "private sub 1 tag"
    type     = string
    default  = "private-sub-1"
}


##Block creates private sub1
variable "private_sub_2_cidr" {
  description = "A list of private subnets inside the VPC"
  type        = string
  default     = "10.100.4.0/24"
}


#Block create tag for private sub2
variable "private-sub-2" {
    description = "private sub 2 tag"
    type     = string
    default  = "private-sub-2"
}


##Block creates private rtb
variable "priv_rtb_cidr" {
  description = "A list of private rt inside the VPC"
  type        = string
  default     = "0.0.0.0/0"
}


#Block create tag for private rtb
variable "priv_rtb" {
    description = "priv rtb tag"
    type     = string
    default  = "priv-rtb"
}


##Block creates pub rtb
variable "pub_rtb_cidr" {
  description = "A list of public rt inside the VPC"
  type        = string
  default     = "0.0.0.0/0"
}


#Block create tag for public rtb
variable "pub_rtb" {
    description = "pub rtb tag"
    type     = string
    default  = "pub-rtb"
}


#Block create tag for igw
variable "csnet-igw" {
    description = "tag for the vpc igw"
    type     = string
    default  = "csnet-igw"
}

## Block creates elastic ip for csnet vpc
variable "csnet_eip" {
  description = "elastic ip for csnet vpc"
  type = string
  default = "vpc"
}


#Block create tag for vpc elastic IP
variable "csnet-eip" {
    description = "tag for the vpc eip"
    type     = string
    default  = "csnet-eip"
}


#Block create tag for vpc ngw
variable "csnet-NAT" {
    description = "tag for the vpc ngw"
    type     = string
    default  = "csnet-NAT"
}

