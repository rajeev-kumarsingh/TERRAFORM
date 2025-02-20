# Initializatio Terraform Block code is written in
# variables.tf file


# Terraform Configuration
provider "aws" {
  # Configuration options
  # Use variable for region
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami = var.amazon_machine_image
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }

}