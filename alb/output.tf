output "aws_alb_name" {
  value = aws_lb.apache-lb.name
}

output "zone_id" {
  value = aws_lb.apache-lb.zone_id
}


output "tom_jerry_id" {
  value = aws_lb_listener.alb-http-listener.id
}

output "alb_sg_name" {
  value = aws_security_group.alb-sg.name
}