#Code block to deploy autoscaling group
resource "aws_autoscaling_group" "apache-asg" {
  name                      = "apache-asg"
  max_size                  = 5
  desired_capacity          = 2
  min_size                  = 2
  target_group_arns         = [ aws_lb_target_group.apache-lb-tg.arn ]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.public_sub_1.id, aws_subnet.public_sub_2.id]
    launch_template {
    id      = aws_launch_template.apache-lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "apache-asg"
    propagate_at_launch = true
  }

}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "apache-asg" {
  autoscaling_group_name = aws_autoscaling_group.apache-asg.id
  lb_target_group_arn    = aws_lb_target_group.apache-lb-tg.id
}