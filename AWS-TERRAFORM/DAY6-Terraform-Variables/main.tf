# Initializing Terraform Block
# Write Terraform Block initialization code in variable.tf file

# Configuring the AWS Provider
provider "aws" {
  # Using variable here from variables.tf file
  region = var.aws_region
}

# Terraform AWS EC2 Instance Configuration
resource "aws_instance" "my_ec2" {
  ami = "ami-04b4f1a9cf54c11d0"
  # Using variable here from variables.tf file
  instance_type = var.instance_type 
  tags = {
    Name = "MyTerraformInstance"
  }
}