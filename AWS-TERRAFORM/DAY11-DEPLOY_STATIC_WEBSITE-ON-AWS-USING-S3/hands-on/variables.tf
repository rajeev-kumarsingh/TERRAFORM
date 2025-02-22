# Terraform AWS provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.88.0"
    }
    # Random Providers
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
  # Stores the state as a given key in a given bucket on Amazon S3.
  # AWS S3 Backend block to manage state management
  # Now terraform start managing state in  backend.tf file
  # Which is in AWS S3 Bucket
  backend "s3" {
    bucket = "my-bucket-e3fd3e6050"
    key    = "backend.tfstate"
    region = "us-east-1"
  }
} 


# Region Variable
variable "N_Virginia" {
  description = "N. Virginia"
  type = string
  default = "us-east-1"
}


# Tags for s3 bucket
variable "s3_tag" {
  description = "AWS S3 Tag or Name"
  default = {
    Name = "staticWebsiteDemo"
    Environment = "Test"
  }
  
}