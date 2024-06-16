#Create an ALB
resource "aws_lb" "apache-lb" {
  name               = "${var.environment}-${var.apache_alb_name}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [var.public_sub_1, var.public_sub_2]
  enable_deletion_protection = var.enable_deletion_protection
  tags = {
    Name = "${var.environment}-${var.apache_alb_name}"
  }
}

#Create ALB listener on port 443
resource "aws_lb_listener" "alb-https-listener" {
  load_balancer_arn = aws_lb.apache-lb.arn
  port              = var.https_port
  protocol          = var.https_protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn
  default_action {
    type             = var.https_action_type
    target_group_arn = var.target_group_arn
  }
}

#Create ALB listener on port 80
resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.apache-lb.arn
  port              = var.http_port
  protocol          = var.http_protocol
  default_action {
    type = var.http_action_type
    redirect {
      port        = var.http_port
      protocol    = var.http_protocol
      status_code = var.status_code
      host        = var.ref_host
      path        = var.ref_host_path
      query       = var.path_query
    }
  }
}

##################################################################
resource "aws_security_group" "alb-sg" {
  name        = var.alb_securitygroup_name
  description = "Allow inbound traffic on port 80 & 443"
  vpc_id      = var.vpc_id
   ingress {
    description      = var.description
    from_port        = 80
    to_port          = 80
    protocol         = var.protocol
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "http port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }

  tags = {
    Name = "${var.environment}-${var.alb_securitygroup_name}"
  }
}


