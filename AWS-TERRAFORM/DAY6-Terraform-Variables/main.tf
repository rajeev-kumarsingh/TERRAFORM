# Initializing Terraform Block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}
# Configuring the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Terraform AWS EC2 Instance Configuration
resource "aws_instance" "my_ec2" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = var.instance_type
  tags = {
    Name = "MyTerraformInstance"
  }
}