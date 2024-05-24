##this block create variable for vpc
variable "create_vpc" {
  description = "identifies the vpc name for all resources"
  type        = bool
  default     = true
}

## this block create variable for cidr
variable "cidr" {
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
variable "public_sub_1" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}




  
  
  
  
  
  

