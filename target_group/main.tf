resource "aws_lb_target_group" "apache-lb-tg" {
  name        = var.name
  port        = var.target_group_port
  protocol    = var.http_protocol
  vpc_id      = var.vpc_id
  health_check {
    interval            = var.interval
    timeout             = var.timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    path                = var.path
    port                = var.http_port
    protocol            = var.http_protocol
  }
}