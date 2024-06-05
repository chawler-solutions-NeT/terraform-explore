resource "aws_lb_target_group" "apache-lb-tg" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  vpc_id      = module.vpc_module.vpc_id
  health_check {
    interval            = var.interval
    timeout             = var.timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    path                = var.path
    port                = var.port
    protocol            = var.protocol
  }
}