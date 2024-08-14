module "ec2_module" {
  source = "../ec2"
  vpc_id = module.vpc_module.vpc_id
  vpc_cidr_block = module.vpc_module.vpc_cidr_block
  public_sub1 = module.vpc_module.public_sub_1
  key_name    = aws_key_pair.TF_key[0].key_name
  environment = "sand"
  ami         = "ami-0eaf7c3456e7b5b68"
  index_count = 4
  instance_copy = "apache-server-ami"
  user_data     = file("${path.module}/project_inventory/ansible.sh")
  # source = 
  # destination = 
  # key_source = 
  # key_destination = 
  depends_on = [ aws_ssm_parameter.private_key, aws_ssm_parameter.public_key ]

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

# # Creating key-pair on AWS using SSH-public key
 resource "aws_key_pair" "TF_key" {
   key_name   = "${var.environment}-TF_key-${count.index}"
   public_key =tls_private_key.rsa[count.index].public_key_openssh
    count = var.key_count
 }

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
   count = var.key_count
}

##################################################
#Store in SSM Parameter
##################################################
resource "aws_ssm_parameter" "private_key" {
   count = var.key_count
  name  = "/${var.environment}/private_key_${count.index}"
  type  = "SecureString"
  value = tls_private_key.rsa[count.index].private_key_pem
}

resource "aws_ssm_parameter" "public_key" {
   count = var.key_count
  name  = "/${var.environment}/public_key_${count.index}"
  type  = "String"
  value = tls_private_key.rsa[count.index].public_key_openssh
}