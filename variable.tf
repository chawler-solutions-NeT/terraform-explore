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
  type        = list(string)
  default     = "10.100.1.0/24"
}