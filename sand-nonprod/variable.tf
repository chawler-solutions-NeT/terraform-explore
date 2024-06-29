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