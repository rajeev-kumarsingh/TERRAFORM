# AWS provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.87.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
    
  }
}



variable "aws_region" {
  description = "The AWS region to deploy resources"
  type = string
  default = "us-east-1"
}

