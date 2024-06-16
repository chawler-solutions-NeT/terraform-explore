##this block create name for apache LB tg
variable "name" {
 description = "name for apache lb  tg"
 type   =   string
 default =  "apache-lb-tg"
}

##this block create port for apache LB tg
variable "target_group_port" {
 description = "port for alb tg"
 type   =   number
 default = 8080 
}

##this block create protocol for apache LB tg
variable "http_protocol" {
 description = "protocol for alb tg"
 type   =   string
 default = "HTTP"
}

##this block create health check interval for apache LB tg
variable "interval" {
 description = "health check interval for alb tg"
 type   =   number
 default = 30
}

##this block create health check timeout for apache LB tg
variable "timeout" {
 description = "health check timeout for alb tg"
 type   =   number
 default = 3
}

##this block create healthy threshold for apache LB tg
variable "healthy_threshold" {
 description = "healthy threshold for alb tg"
 type   =   number
 default = 2
}

#this block create unhealthy threshold for apache LB tg
variable "unhealthy_threshold" {
 description = "unhealthy threshold for alb tg"
 type   =   number
 default = 2
}

#this block create healthy check path for apache LB tg
variable "path" {
 description = "health check for alb tg"
 type   =   string
 default = "/"
}

#this block create healthy check port for apache LB tg
variable "http_port" {
 description = "health check port for alb tg"
 type   =   string
 default ="8080"
}

variable "vpc_id" {
  description = "VPC ID from the VPC module"
}

variable "environment" {
  description = "Name of the specific environment"
}