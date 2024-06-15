variable "validation_method" {
  description = "How to validate your domain"
  type = string
  default = "DNS"
}

variable "key_algorithm" {
  description = "The type of encryption"
  type = string
  default = "RSA_2048"
}

variable "domain_tag_name" {
  description = "Tag name to assign to the domain"
  type        = string
  default     = "bisnuel-public-cert"
}

variable "domain_name" {
  description = "Domain name of choice"
  type = string
}

variable "route53_record" {
  description = "List of Route 53 records with fqdn attribute"
}
