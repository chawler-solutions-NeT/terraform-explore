variable "apache-asg" {
    description = "the name of apache-asg"
    type    = string
    default = "apache-asg"
}

variable "max_size" {
    description = "size of apache asg"
    type = number
    default = 5
}

variable "desired_capacity" {
    description = "desired capacity of apache asg"
    type = number
    default = 2
}

variable "min_size" {
    description = "size of apache asg"
    type = number
    default = 2
}

variable "health_check_grace_period" {
    description = "health check of apache asg"
    type = number
    default = 300
}

variable "health_check_type" {
    description = "health check type for apache asg"
    type = string
    default = "ELB"
}

variable "force_delete" {
    description = "to force delete option of apache asg"
    type = bool
    default = "true"
}

variable "environment" {
  description = "Name of the specific environment"
}

variable "target_groups_arn" {}
variable "public_sub_1" {}
variable "public_sub_2" {}
variable "launch_template_id" {}
variable "lb_target_group" {}
