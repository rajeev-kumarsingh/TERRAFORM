# AWS OS IMAGE
data "aws_ami" "ubuntu" {
  most_recent = true # Ensure we get the latest AMI version
  owners = ["099720109477"] # Canonical (Official Ubuntu AMI owner ID)

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

# Security Groups
data "aws_security_group" "find-by-name" {
  name = "22-80-443-sg"

  
}

# Find Security Group by Tag
data "aws_security_groups" "find-sg-by-tag" {
  filter {
    name   = "tag:Name"
    values = ["22-80-443-sg"]  # Replace with your tag name
  }
}

# Retrieve All Availability Zones
data "aws_availability_zones" "available" {
  
}

# To retrieve AWS account details using Terraform
# Get AWS Account ID, User, and ARN
data "aws_caller_identity" "current" {}
