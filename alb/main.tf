#Create an ALB
resource "aws_lb" "apache-lb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [module.vpc_module.public_sub_1, module.vpc_module.public_sub_2]
  enable_deletion_protection = var.enable_deletion_protection
  tags = {
    Name = var.name
  }
}

#Create ALB listener on port 443
resource "aws_lb_listener" "alb-https-listener" {
  load_balancer_arn = aws_lb.apache-lb.arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = module.acm.certificate_arn
  default_action {
    type             = var.type
    target_group_arn = aws_lb_target_group.apache-lb-tg.arn
  }
}

#Create ALB listener on port 80
resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.apache-lb.arn
  port              = var.port
  protocol          = var.protocol
  default_action {
    type = var.type
    redirect {
      port        = var.port
      protocol    = var.protocol
      status_code = var.status_code
      host        = var.host
      path        = var.path
      query       = var.query
    }
  }
}

##################################################################
resource "aws_security_group" "alb-sg" {
  name        = var.name
  description = "Allow inbound traffic on port 80 & 443"
  vpc_id      = module.vpc_module.vpc_id
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
    Name = var.name
  }
}


