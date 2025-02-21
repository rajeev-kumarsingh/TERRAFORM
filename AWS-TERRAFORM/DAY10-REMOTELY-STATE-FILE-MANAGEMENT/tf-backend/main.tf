# AWS PROVIDER BLOCK AND BACKEND BLOCK IS WRITTEN IN variables.tf file

# AWS CONFIGURATION
provider "aws" {
  # Configuration of AWS
  region = var.aws_region
}

# CREATE aws_instance resource
resource "aws_instance" "tf-backend" {
  ami = var.AWS_UBUNTU_AMI
  instance_type = var.aws_instance_type
  key_name = "awswebserverkey"
  vpc_security_group_ids = ["sg-034dc0cc873c9388a"]
  tags = var.INSTANCE_NAME

  
}

data "aws_s3_objects" "tf_backend" {
  bucket = "my-bucket-e3fd3e6050"  # Replace with your actual bucket name
}

