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

  image_id = aws_ami_from_instance.apache_copy.id
  user_data = "${base64encode(<<-EOF
              #!/bin/bash
              sudo nohup java -jar /opt/tomcat9/webapps/spring-petclinic-2.4.2.war &
              EOF
          )}"
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
    subnet_id = module.vpc_module.public_sub_1.id
    security_groups = [aws_security_group.apache-server.id]
  }


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "apache-lt"
    }
  }

}