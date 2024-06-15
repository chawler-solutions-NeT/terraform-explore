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
  domain_name = module.route_53.route53_record_name
  route53_record = module.route_53.route53_record_fqdn
}

module "auto_scaling" {
  source = "../auto_scaling"
  target_groups_arn   = module.target_group.target_group_arn
  public_sub_1        = module.vpc_module.public_sub_1
  public_sub_2        = module.vpc_module.public_sub_2
  launch_template_id  = module.launch_template.launch_template_id
  lb_target_group     = module.target_group.target_group_id
}

module "alb" {
  source              = "../alb"
  public_sub_1        = module.vpc_module.public_sub_1
  public_sub_2        = module.vpc_module.public_sub_2
  acm_certificate_arn = module.acm.certificate_arn
  target_group_arn    = module.target_group.target_group_arn
  vpc_id              = module.vpc_module.vpc_id
}

module "route_53" {
  source = "../route_53"
  aws_lb_name = module.alb.aws_alb_name
  aws_zone_id = module.alb.aws_alb_name
  validation_option = module.acm.validation_option
}

module "target_group" {
  source = "../target_group"
  vpc_id = module.vpc_module.vpc_id
}

module "launch_template" {
  source = "../launch_template"
  image_id = module.ec2_module.ami_from_instance
  subnet_id = module.vpc_module.public_sub_1
  security_groups = module.ec2_module.security_group_id
  key_pair = aws_key_pair.bash.key_name
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "bash" {
  key_name   = "bash"
  public_key = file("~/keypair/devops.pub")
}
