module "ec2_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.bash.key_name
  environment = "sand"
}

module "vpc_module" {
  source = "../vpc"
  environment = "sand"
  vpc_cidr = "10.120.0.0/16"
  public_sub_1_cidr = "10.120.1.0/24"
  public_sub_2_cidr = "10.120.2.0/24"
  private_sub_1_cidr = "10.120.3.0/24"
  private_sub_2_cidr = "10.120.4.0/24"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "bash" {
  key_name   = "sand-bash"
  public_key = file("~/keypair/devops.pub")
}
