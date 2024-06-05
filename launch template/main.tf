resource "aws_launch_template" "apache-lt" {
  name = var.name
  iam_instance_profile {
    name = var.instance_profile
  }
  
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
    }
  }

  image_id = module.ec2_module.ami_from_instance

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = var.instance-market_option
  }

  instance_type = var.instance_type
  key_name = aws_key_pair.bash.key_name
  metadata_options {
    http_endpoint               = var.http_endpoint
    http_tokens                 = var.http_tokens
    http_put_response_hop_limit = var.http_put_response_hop_limit
    instance_metadata_tags      = var.instance_metadata-tags
  }
  monitoring {
    enabled = var.enabled
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    subnet_id = module.vpc_module.public_sub_1
    security_groups = [module.ec2_module.security_group_id]
  }


  tag_specifications {
    resource_type = var.resource_type

    tags = {
      Name = var.name
    }
  }

}