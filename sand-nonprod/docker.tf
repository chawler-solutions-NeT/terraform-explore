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
  depends_on = [ aws_ssm_parameter.jenkins_key, aws_ssm_parameter.jenkins_key ]

}

# Creating key-pair on AWS using SSH-jenkins key
 resource "aws_key_pair" "TF_key" {
   key_name   = "${var.environment}-TF_key"
   public_key =tls_public_key.rsa.public_key_openssh
  }

resource "tls_jenkins_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

##################################################
#Store in SSM Parameter
##################################################
resource "aws_ssm_parameter" "jenkins_key" {
  name  = "/${var.environment}/jenkins_key"
  type  = "SecureString"
  value = tls_jenkins_key.rsa.jenkins_key_pem
}

resource "aws_ssm_parameter" "jenkins_key" {
  name  = "/${var.environment}/jenkins_key"
  type  = "String"
  value = tls_jenkins_key.rsa.jenkins_key_openssh
}