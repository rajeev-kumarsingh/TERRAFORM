terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.88.0"
    }

  }
}

provider "aws" {
  # Write AWS Configuration here
  region = "us-east-1"
}