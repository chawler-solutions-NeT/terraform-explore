resource "aws_launch_template" "worker" {
  name_prefix   = "worker-"
  image_id      = var.ami_id
  instance_type = var.worker_instance_type

  user_data = base64encode(file("user_data_worker.sh"))

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.worker.id]
  }


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  launch_template {
    id      = aws_launch_template.worker.id
    version = "$Latest"
  }
  
  min_size     = var.desired_workers
  max_size     = var.desired_workers
  desired_capacity = var.desired_workers

  vpc_zone_identifier = [module.vpc_module.public_sub_1]
  health_check_type   = "EC2"

  tag {
    key                 = "Name"
    value               = "swarm-worker"
    propagate_at_launch = true
  }
}
