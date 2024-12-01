# boolean - condition for true or false
# String - combination of alphanumeric characters deliminated with a double quote ""
#Set of strings -  a group of strings deliminated with
# square brackets []
#provisioner: file, remote-exec, local-exec (requires connection block)

resource "aws_instance" "ansible-server" {
  //count = length(local.instance_names)
  # for_each                        = local.instance_names
  ami                             = var.ami
  instance_type                   = var.instance_type
  key_name                        = var.key_name    //this is assumed that you have already created/uploaded you keypair to aws keypair
  vpc_security_group_ids          = var.vpc_security_group_ids 
  associate_public_ip_address     = var.associate_public_ip
  subnet_id                       = var.public_sub1
  iam_instance_profile            = var.instance_profile
  user_data                       = var.user_data != "" ? var.user_data : null
  # instance_market_options {
  #   spot_options {
  #     max_price = 0.0400
  #   }
  #   market_type = var.ec2_market_type
  # }
    ebs_block_device {
        device_name = "/dev/sdf"
        delete_on_termination = true
        volume_size = var.block_size
        volume_type = var.block_type
    }
    root_block_device {
        delete_on_termination = true
        volume_size = var.block_size
        volume_type = var.block_type
    }
    
  tags = {
    Name = "${var.environment}-${var.instance_name}"   ## assuming for_each option is in use ${var.environment}-${each.value}
    Owner = "Devops",
    Environment = "${var.environment}"
    OS = "Linux"
  }
    ##Name = "${var.environment}-${var.ec2_apache}" // dev-apache-server
    # provisioner "file" {
    # source	= var.source           
    # destination	= var.destination
    # }

    # provisioner "file" {
    # source	= var.key_source           
    # destination	= var.key_destination
    # }

      lifecycle {
    ignore_changes = all
    }
  }


############Creates a copy of the Instance AMI
# resource "aws_ami_from_instance" "apache_copy" {
#   count = 3
#   name               = var.instance_copy
#   source_instance_id = aws_instance.apache-server.id
#   snapshot_without_reboot = true

#   tags = {
#     Name = "${var.environment}-apache-server-ami" // sand-apache-server-ami
#   }
# }