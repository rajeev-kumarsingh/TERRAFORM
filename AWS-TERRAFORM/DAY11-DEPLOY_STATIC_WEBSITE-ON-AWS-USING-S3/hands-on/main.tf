# Terraform AWS and RANDOM provider block is written in the variables.tf file
# AWS S3 backend block is written in the variables.tf file
# AWS S3 backend block is used to manage state file remotely on AWS S3

# Terraform configuration
provider "aws" {
  # Write configuration here 
  region = var.N_Virginia
}

# Use Random provider to create random number
resource "random_id" "ran_pro_ex" {
  byte_length = 5
}

# Resources to create S3 bucket creation
# Step1
resource "aws_s3_bucket" "demo-website" {
  bucket = "demo-website-${random_id.ran_pro_ex.hex}"
  tags = var.s3_tag
  
}
# Step2
#aws_s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.demo-website.id
  block_public_acls = false # Defaults to true
  block_public_policy = false # Defaults to true
  ignore_public_acls = false # Defaults to true
  restrict_public_buckets = false # Defaults to true


}
# Step3
# Bucket versioning
resource "aws_s3_bucket_versioning" "bucket-version" {
  bucket = aws_s3_bucket.demo-website.id
  versioning_configuration {
    status = "Disabled" # By default it is "Disable", Change to enable if needed
  }
  
}

# Till here we wrote the bucket creation code 
# Now Upload the File
 #Step 4
# Upload index.html file
resource "aws_s3_object" "index-file" {
  bucket = aws_s3_bucket.demo-website.id
  key = "index.html"
  source = "./index.html"
  content_type = "text/html"
  
}
# Step5
# Upload error.html file
resource "aws_s3_object" "css-file" {
  bucket = aws_s3_bucket.demo-website.id
  key = "styles.css"
  source = "./styles.css"
  content_type = "text/css"
  
}

# Till here we created bucket, enables public access, kept bucket versioning diasbled(default option) and uploaded index.html, style.css files
# Now to deploy static website, we need a bucket policy
# Step 6
# Bucket Policy
# The bucket policy must allow public read access to both files:

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.demo-website.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.demo-website.id}/*"]
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.demo-website.id}"]
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:PutBucketPolicy"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.demo-website.id}"]
    }
  ]
}

POLICY
}

# Till now we did everything, now the last one is to enable Static website hosting option(In AWS CONSOLE it is available at last option)
# To enable Static Website Hosting for an S3 bucket using Terraform, you need to use the aws_s3_bucket_website_configuration resource.
#aws_s3_bucket_website_configuration
#Step7
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.demo-website.id
  index_document {
    suffix = "index.html"
  }
  
}
