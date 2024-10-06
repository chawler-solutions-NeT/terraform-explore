output "vpc_cidr_block" {
  value = module.vpc_module.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc_module.vpc_id
}

output "vpc_arn" {
  value = module.vpc_module.vpc_arn
}

output "public_sub_1" {
  value = module.vpc_module.public_sub_1
}

output "public_sub_2" {
  value = module.vpc_module.public_sub_2
}

output "manager_asg_id" {
  value = aws_autoscaling_group.manager.id
}

output "worker_asg_id" {
  value = aws_autoscaling_group.worker.id
}
