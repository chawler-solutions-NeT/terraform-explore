output "target_group_arn" {
  value = aws_lb_target_group.apache-lb-tg.arn
}

output "target_group_id" {
  value = aws_lb_target_group.apache-lb-tg.id
}