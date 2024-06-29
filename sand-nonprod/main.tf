module "ec2_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.TF_key[0].key_name
  environment = "sand"
  ami         = "ami-0eaf7c3456e7b5b68"
  index_count = 3
  instance_copy = "apache-server-ami"

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
resource "aws_key_pair" "TF_key" {
  key_name   = "${var.environment}-TF_key-${count.index}"
  public_key =tls_private_key.rsa[0].public_key_openssh
  count = var.key_count
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
  count = var.key_count
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa[0].private_key_pem
  filename = "${var.environment}-tfkey"
  count = var.key_count
}
