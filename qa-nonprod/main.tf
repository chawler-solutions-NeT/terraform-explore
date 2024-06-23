module "ec2_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.TF_key.key_name
  environment = "qa"
  ami = "ami-0eaf7c3456e7b5b68"
}

module "vpc_module" {
  source = "../vpc"
  environment = "qa"
  vpc_cidr = "10.130.0.0/16"
  public_sub_1_cidr = "10.130.1.0/24"
  public_sub_2_cidr = "10.130.2.0/24"
  private_sub_1_cidr = "10.130.3.0/24"
  private_sub_2_cidr = "10.130.4.0/24"
}

# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "TF_key" {
  key_name   = "${var.environment}-TF_key"
  public_key =tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "${var.environment}-tfkey"
}

# Creating key-pair on AWS using SSH-public key
#resource "aws_key_pair" "bash" {
  #key_name   = "sand-bash"
  #public_key = file("~/keypair/devops.pub")
#}