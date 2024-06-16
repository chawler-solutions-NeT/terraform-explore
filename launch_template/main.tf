resource "aws_launch_template" "apache-lt" {
  name = "${var.environment}-${var.name}"
  iam_instance_profile {
    name = var.instance_profile
  }
  
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
    }
  }

  image_id = var.image_id

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = var.instance-market_option
  }

  instance_type = var.instance_type
  key_name = var.key_pair
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
    subnet_id = var.subnet_id
    security_groups = [var.security_groups]
  }


  tag_specifications {
    resource_type = var.resource_type

    tags = {
      Name = "${var.environment}-${var.name}"
    }
  }

}