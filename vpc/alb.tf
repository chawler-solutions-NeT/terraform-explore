#Create an ALB
resource "aws_lb" "apache-lb" {
  name               = "apache-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public_sub_1.id, aws_subnet.public_sub_2.id]
  enable_deletion_protection = false
  tags = {
    Name = "apache-lb"
  }
}

#Create ALB listener on port 443
resource "aws_lb_listener" "alb-https-listener" {
  load_balancer_arn = aws_lb.apache-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache-lb-tg.arn
  }
}

#Create ALB listener on port 80
resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.apache-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }
}

##################################################################
resource "aws_security_group" "alb-sg" {
  name        = "apache-alb-sg"
  description = "Allow inbound traffic on port 80 & 443"
  vpc_id      = aws_vpc.csnet_vpc.id
   ingress {
    description      = "http port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
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
    Name = "apache-alb-sg"
  }
}


