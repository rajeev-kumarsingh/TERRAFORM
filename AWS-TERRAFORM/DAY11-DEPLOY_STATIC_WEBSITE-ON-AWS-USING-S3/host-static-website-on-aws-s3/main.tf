# Terraform provider and backend configurations (Defined in variables.tf)
provider "aws" {
  region = var.aws_region
}

# Generate a random ID to ensure bucket name uniqueness
resource "random_id" "random_provider_example" {
  byte_length = 5
}

# Create AWS S3 Bucket for hosting a static website
resource "aws_s3_bucket" "website_demo" {
  bucket = "static-website-demo-${random_id.random_provider_example.hex}"

  tags = {
    Name        = "staticWebsiteDemo"
    Environment = "Test"
  }

  
  
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_demo.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

}


# Enable/Disable bucket versioning
resource "aws_s3_bucket_versioning" "my_versioning" {
  bucket = aws_s3_bucket.website_demo.id

  versioning_configuration {
    status = "Disabled"  # Change to "Enabled" if versioning is needed
  }
}

# Make S3 Bucket Public (Optional) using ACL
resource "aws_s3_bucket_acl" "acl_control" {
  bucket = aws_s3_bucket.website_demo.id
  acl    = "public-read"
}

# Upload index.html file
resource "aws_s3_object" "index_file" {
  bucket       = aws_s3_bucket.website_demo.id
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"
}

# Upload error.html file
resource "aws_s3_object" "error_file" {
  bucket       = aws_s3_bucket.website_demo.id
  key          = "error.html"
  source       = "./error.html"
  content_type = "text/html"
}

# Bucket Policy to Allow Public Access
resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.website_demo.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.website_demo.id}/*"
    }
  ]
}
POLICY
}
