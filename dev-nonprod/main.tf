module "ec2_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.bash.key_name
  environment = "dev"
}

module "vpc_module" {
  source = "../vpc"
  environment = "dev"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "bash" {
  key_name   = "dev-bash"
  public_key = file("~/keypair/devops.pub")
}
