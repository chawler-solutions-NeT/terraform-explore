terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::000654510656:role/vault-admin"
  }
}

