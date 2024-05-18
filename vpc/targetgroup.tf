resource "aws_lb_target_group" "apache-lb-tg" {
  name        = "apache-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.csnet_vpc.id
  health_check {
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = "/"
    port                = "8080"
    protocol            = "HTTP"
  }
}