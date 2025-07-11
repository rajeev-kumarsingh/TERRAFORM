provider "aws" {
  region = "us-east-1"
}


# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}




# Add a new VPC resource block with static values
# resource "aws_subnet" "variables-subnet" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.250.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name      = "sub-variables-us-east-1a"
#     Terraform = "true"
#   }
# }

# Add a new VPC resource block using variables 
resource "aws_subnet" "variable_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.variable_sub_cidr
  availability_zone = var.variable_sub_az
  #map_customer_owned_ip_on_launch = var.variable_sub_auto_ip
  map_public_ip_on_launch = var.variable_sub_auto_ip
  tags = {
    Name = "sub-variables-${var.variable_sub_az}"
  }
}

