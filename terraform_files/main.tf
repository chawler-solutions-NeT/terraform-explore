module "ec2_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.bash.key_name
}

module "vpc_module" {
  source = "../vpc"
}

module "acm" {
  source = "../acm"
  domain_name = var.domain_name
  route53_record = aws_route53_record.apache-domain
}

module "autoscaling" {
  source = "../auto_scaling"
  target_groups_arn   = aws_lb_target_group.apache-lb-tg.arn
  public_sub_1        = module.vpc_module.public_sub_1
  public_sub_2        = module.vpc_module.public_sub_2
  launch_template_id  = aws_launch_template.apache-lt.id
  lb_target_group     = aws_lb_target_group.apache-lb-tg.id
}


# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "bash" {
  key_name   = "bash"
  public_key = file("~/keypair/devops.pub")
}
