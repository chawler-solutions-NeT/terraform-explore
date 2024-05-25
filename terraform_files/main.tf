module "ec2_module" {
  source = "../ec2"
}

module "vpc_module" {
  source = "../vpc"
}
