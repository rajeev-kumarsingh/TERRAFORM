# Stores the state as a given key in a given bucket on Amazon S3
terraform {
  backend "s3" {
    bucket = "my-bucket-e3fd3e6050" # name of the bucket
    key = "backend.tfstate" # Name of the terraform state file
    region = "us-east-1" # Values of the region where S3 bucket (my-bucket-e3fd3e6050) resides in
  }
}

# we can use Dynamodb as we instead of s3 
