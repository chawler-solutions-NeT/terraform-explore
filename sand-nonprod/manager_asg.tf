resource "aws_autoscaling_group" "manager_asg" {
  desired_capacity     = var.manager_count
  max_size             = var.manager_count
  min_size             = var.manager_count

  vpc_zone_identifier  = [module.vpc_module.public_sub_1]
  launch_template {
    id      = aws_launch_template.manager_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "swarm-manager"
    propagate_at_launch = true
  }

  depends_on = [ aws_ssm_parameter.public_key, module.ansible_module ]
}
