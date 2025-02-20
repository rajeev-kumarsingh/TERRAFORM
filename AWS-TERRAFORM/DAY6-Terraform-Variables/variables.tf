# It is a separate file to store variables definitions

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type = string
  default = "us-east-1"
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type = string
  default = "t2.micro"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}

# Use these variables in main.tf 
