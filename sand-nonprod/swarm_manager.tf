resource "aws_launch_template" "manager" {
  name_prefix   = "manager-"
  image_id      = var.ami_id
  instance_type = var.manager_instance_type

  user_data = base64encode(file("user_data_manager.sh"))

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.manager.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "manager" {
  launch_template {
    id      = aws_launch_template.manager.id
    version = "$Latest"
  }
  
  min_size     = var.desired_managers
  max_size     = var.desired_managers
  desired_capacity = var.desired_managers

  vpc_zone_identifier = [module.vpc_module.public_sub_1]
  health_check_type   = "EC2"

  tag {
    key                 = "Name"
    value               = "swarm-manager"
    propagate_at_launch = true
  }
}
