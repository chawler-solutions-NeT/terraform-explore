## this block create name for aws route 53
variable "domain_name" {
  description = "Domain name of choice"
  type = string
  default = "sammybisnuel.net"
}

## this block create option type for aws route 53
variable "record_type" {
  description = "type for route 53"
  type = string
  default = "A"
}

## this block create target health for aws route 53
variable "evaluate_target_health" {
  description = "evaluate target health for route 53"
  type = bool
  default =  true
}

variable "aws_lb_name" {
  description = "aws lb name"
}

variable "aws_zone_id" {
  description = "aws lb zone id"
}

variable "private_zone" {
  description = "route 53 private zone"
  type = bool
  default = false
}

variable "validation_option" {
  description = "route 53 validation option"
}

variable "route_53_overwrite_option" {
  description = "overwrite option under route 53"
  type = bool
  default = true
}

variable "time_to_live" {
  description = "traffic time to live"
  type = number
  default = 60
}

variable "environment" {
  description = "Name of the specific environment"
}
