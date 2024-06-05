## this block create name for aws route 53
variable "domain_name" {
  description = "Domain name of choice"
  type = string
  default = "www.sammybisnuel.net"
}

## this block create option type for aws route 53
variable "type" {
  description = "type for route 53"
  type = string
  default = "A"
}

## this block create target health for aws route 53
variable "evaluate_target_health" {
  description = "evaluate target health for route 53"
  type = bool
  default = true
}