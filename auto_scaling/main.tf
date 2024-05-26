#Code block to deploy autoscaling group
resource "aws_autoscaling_group" "apache-asg" {
  name                      = var.apache-asg
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  target_group_arns         = [ var.target_groups_arn ]
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  force_delete              = var.force_delete
  vpc_zone_identifier       = [var.public_sub_1, var.public_sub_2]
    launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.apache-asg
    propagate_at_launch = true
  }

}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "apache-asg" {
  autoscaling_group_name = aws_autoscaling_group.apache-asg.id
  lb_target_group_arn    = var.lb_target_group
}