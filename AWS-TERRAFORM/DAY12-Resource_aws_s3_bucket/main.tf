# Terraform AWS and RANDOM provider block is written in the variables.tf file
# AWS S3 backend block is written in the variables.tf file
# AWS S3 backend block is used to manage state file remotely on AWS S3

# Terraform configuration
provider "aws" {
  # Write configuration here 
  region = var.N_Virginia
  
}






resource "aws_s3_directory_bucket" "my_bucket"  {
  bucket = my-existing-bucket-123--use1-az4--x-s3 # This will be updated by the import, and later removed.
  
}

