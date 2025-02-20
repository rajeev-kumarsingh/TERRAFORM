terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  default = "us-east-1"
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type = string
  default = "t2.micro"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type = string
  default = "ExampleAppServerInstance"
}

variable "amazon_machine_image" {
  description = "Ubuntu Server 24.04 LTS (HVM),EBS General Purpose (SSD) Volume Type"
  type = string
  default = "ami-04b4f1a9cf54c11d0"
  
}