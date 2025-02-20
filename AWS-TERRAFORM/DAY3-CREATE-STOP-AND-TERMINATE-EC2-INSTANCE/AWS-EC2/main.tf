# TERRAFORM AWS_PROVIDER
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}
# Here use environment variable for credentials or hardcode below your AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY
provider "aws" {
  # Configuration options
  region = "us-east-1"
}
# Resource type and other details related to that specific resource
resource "aws_instance" "K8s-Master-Node" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.medium"
  key_name = "awswebserverkey"
  vpc_security_group_ids = ["sg-04a0292e2d6229ea0"]
  tags = {
    Name = "k8s-control-plane"
    # Stop the instance instead of terminating
    instance_state = "stopped"
  }
}

resource "aws_instance" "K8s-Worker-Node-01" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.medium"
  key_name = "awswebserverkey"
  vpc_security_group_ids = ["sg-034dc0cc873c9388a"]
  tags = {
    Name = "k8s-worker-node-1"
    # Stop the instance instead of terminating
    instance_state = "stopped"
  }
}

resource "aws_instance" "K8s-Worker-Node-02" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.medium"
  key_name = "awswebserverkey"
  vpc_security_group_ids = ["sg-034dc0cc873c9388a"]
  tags = {
    Name = "k8s-worker-node-2"
    # Stop the instance instead of terminating
    instance_state = "stopped"
  }
}