# AWS provider is written in variables.tf file

# AWS CONFIGURATION
provider "aws" {
  # Using variables.tf file variable
  region = var.aws_region
   
}

# Add an S3 bucket resource

resource "aws_s3_bucket" "my-unique-terraform-bucket-2025" {
  bucket = "my-unique-terraform-bucket-2025" # must be unique globaly
  tags = {
    Name = "MyTerraformS3Bucket"
    Environment = "Dev"
  }
}

# To enable bucket versioning for the bucket, add
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my-unique-terraform-bucket-2025.id
  versioning_configuration {
    status = "Disabled"
  }
  
}

# Make S3 Bucket Private/Public(Optional)
# To control access using ACL(Access Control List)
#resource "aws_s3_bucket_acl" "example_acl" {
  #bucket = aws_s3_bucket.my-unique-terraform-bucket-2025.id
  #acl = "private" # Options: private, public-read, public-read-write, authenticated-read
  
#}

# Use the Object Ownership setting instead: Modify your S3 bucket resource to explicitly set the ownership control:
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my-unique-terraform-bucket-2025.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


# Upload file to s3 bucket
resource "aws_s3_object" "bucket_file" {
  bucket = aws_s3_bucket.my-unique-terraform-bucket-2025.bucket
  source = "./demofile.txt"
  key =  "myfile.txt"

}