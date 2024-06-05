##this block create name for apache LB
variable "name" {
 description = "name for apache LB"
 type   =   string
 default = "apache-lb"        
}

##this block create internal option for apache LB
variable "internal" {
 description = "internal option for apache LB"
 type   =   bool
 default = false       
}

##this block create load  balancer  type for apache LB
variable "load_balancer_type" {
 description = "load balancer type for apache LB"
 type   =   string
 default = application       
}

##this block create deletion protection for apache LB
variable "enable_deletion_protection" {
 description = "to enable deletion protection for apache LB"
 type   =   bool
 default = false       
}

##this block create the port number for apache LB
variable "port" {
 description = "port number for apache LB"
 type   =   number
 default = 443       
}

##this block create the protocol for apache LB
variable "protocol" {
 description = "protocol for apache LB"
 type   =   string
 default = "HTTPS"      
}

##this block create the ssl policy for apache LB
variable "ssl_policy" {
 description = "ssl policy for apache LB"
 type   =   string
 default =  "ELBSecurityPolicy-2016-08"     
}

##this block create default action for apache LB
variable "type" {
 description = "default action type for apache LB"
 type   =   string
 default =  "forward"     
}

##this block create the port number for apache LB listener
variable "port" {
 description = "port number for apache LB listener"
 type   =   number
 default = 80       
}

##this block create the protocol for apache LB listener
variable "protocol" {
 description = "protocol for apache LB listener"
 type   =   string
 default = "HTTP"      
}

##this block create default action for apache LB listener
variable "type" {
 description = "default action type for apache LB listener"
 type   =   string
 default =  "redirect"     
}

##this block create status code for apache LB listener
variable "status_code" {
 description = "status code for alb listener"
 type   =   string
 default =   "HTTP_301"    
}

##this block create status code for apache LB listener
variable "status_code" {
 description = "status code for alb listener"
 type   =   string
 default =   "HTTP_301"    
}

##this block create host for apache LB listener
variable "host" {
 description = "host for alb listener"
 type   =   string
 default =  "#{host}"     
}

##this block create host for apache LB listener
variable "path" {
 description = "path for alb listener"
 type   =   string
 default = "/#{path}"      
}

##this block create query for apache LB listener
variable "query" {
 description = "query for alb listener"
 type   =   string
 default =  "#{query}"     
}

##this block create security group for apache LB 
variable "name" {
 description = "name for security group for alb"
 type   =   string
 default =   "apache-alb-sg"   
}

##this block create description option for apache LB sg
variable "description" {
 description = "description for alb sg"
 type   =   string
 default =   "http port"   
}

##this block create tcp protocol for apache LB sg
variable "protocol" {
 description = "tcp protocol for alb sg"
 type   =   string
 default = "tcp"     
}

##this block create tag for apache LB sg
variable "name" {
 description = "name for alb sg"
 type   =   string
 default =  "apache-alb-sg"
}