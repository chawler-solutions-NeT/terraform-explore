resource "aws_launch_template" "apache-lt" {
  name = "apache-lt"
  iam_instance_profile {
    name = "ec2Instanceprofile"
  }
  
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 10
    }
  }

  image_id = module.ec2_module.ami_from_instance

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.medium"
  key_name = aws_key_pair.bash.key_name
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id = module.vpc_module.public_sub_1
    security_groups = [module.ec2_module.security_group_id]
  }


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "apache-lt"
    }
  }

}