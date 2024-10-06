resource "aws_launch_template" "manager_launch_template" {
  name          = "manager-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data = base64encode(data.template_file.manager_userdata.rendered)
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  instance_market_options {
    spot_options {
      max_price = 0.0400
    }
    market_type = var.ec2_market_type
  }
  network_interfaces {
    subnet_id    = module.vpc_module.public_sub_1
    associate_public_ip_address = true
    security_groups = [aws_security_group.swarm_sg.id]
  }
}
