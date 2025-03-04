# Create 2 subnets using count
# CIDR 10.0.0.0/24 and 10.0.1.0/24
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.88.0"
    }
  }
}
variable "aws_region" {
  description = "Region of AWS where resources will get created"
  type = string
  default = "us-east-1"
}

locals {
  project = "project1"
}
provider "aws" {
  region = var.aws_region
  
}

resource "aws_vpc" "my-vpc" { 
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.project}-vpc" # O/P project1-vpc
  }

  
}
resource "aws_subnet" "my-subnet" {
  vpc_id = aws_vpc.my-vpc.id 
  cidr_block = "10.0.${count.index}.0/24"
  count = 2
  tags = {
    Name = "${local.project}-subnet-${count.index}" # Ex O/P - project1-subnet-0 project1-subnet-1
  }
  
}

####################################################################
# # Create 4 ec2 instances, 2 in each subnet
# resource "aws_instance" "my-server" {
#   ami = "ami-04b4f1a9cf54c11d0"
#   instance_type = "t2.micro"
#   count = 4 # Will create 4 EC2 Instances
#   subnet_id = element(aws_subnet.my-subnet[*].id, count.index % length(aws_subnet.my-subnet)) 
#   # count.index % length(aws_suubnet.my-subnet) 
#   # O/P - 
#   #0%2 = 0
#   #1%2 = 1
#   #2%2 = 0
#   #3%2 = 1
#   tags = {
#     Name = "${local.project}-instance-${count.index}" 
#   }

  
# }

#############################################################

#############################################################
# 3. Create 2 Subnet, 2 ec2 instance, 1 in each subnet

# - subnet1 : ec2-1(ubuntu)
# - subnet2 : ec2-2(amazon-linux)
resource "aws_instance" "my-server" {
  for_each = {
    "ubuntu" ={
      ami           = "ami-04b4f1a9cf54c11d0" # Ubuntu Image
      instance_type = "t2.micro"
      subnet_id     = aws_subnet.my-subnet[0].id
      tags = {
        Name = "Ubuntu-EC2-Instance"
      }
    }
    "amazon-linux" ={
      ami           = "ami-05b10e08d247fb927" # Amazon Linux
      instance_type = "t2.micro"
      subnet_id     = aws_subnet.my-subnet[1].id
      tags = {
        Name = "Amazon-linux-EC2-Instance"
      }
    }
  }
  ami = each.value.ami
  instance_type = each.value.instance_type
  subnet_id = each.value.subnet_id
  tags = each.value.tags
}
# Used each.value to reference properties:

# each.value.ami gets the AMI for each instance.
# each.value.instance_type gets the instance type.
# each.value.subnet_id assigns the correct subnet.

#############################################################



output "vpc_id" {
  description = "VPC ID to create resources"
  value = aws_vpc.my-vpc.id  
}
output "subnet-id-1" {
  description = "Get Subnets ID"
  value = aws_subnet.my-subnet[0].id
}
output "subnet-id-2" {
  value = aws_subnet.my-subnet[1].id
  
}


