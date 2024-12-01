resource "aws_autoscaling_group" "worker_asg" {
  desired_capacity     = var.worker_count
  max_size             = var.worker_count
  min_size             = var.worker_count

  vpc_zone_identifier  = [module.vpc_module.public_sub_1]
  launch_template {
    id      = aws_launch_template.worker_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "swarm-worker"
    propagate_at_launch = true
  }

  depends_on = [ aws_ssm_parameter.public_key ]
}
