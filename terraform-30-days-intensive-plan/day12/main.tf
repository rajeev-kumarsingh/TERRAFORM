# Provider Block
provider "aws" {
  region = "us-east-1"

}

# data block
# Retrive the list of Azs in the current AWS region
data "aws_availability_zones" "available" {


}
data "aws_region" "current" {

}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (Ubuntu)

  tags = {
    Name = "Latest Ubuntu 22.04 LTS"
  }
}


# locals bloc
locals {
  team        = "api-mgmt-dev"
  application = "corp_api"
  server_name = "ec2-${var.environment}-api-${var.variable_sub_az}"
}



# Define the VPC
# VPC Resource Block
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
    Environment = "dev"
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


# Resourse Block
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


# Define Web Server
# Resource Block
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id # add `.id` to fetch AMI ID
  instance_type = var.instance_type
  subnet_id     = aws_subnet.variable_subnet.id

  tags = {
    Name  = local.server_name
    Owner = local.team
    App   = local.application
  }
}

