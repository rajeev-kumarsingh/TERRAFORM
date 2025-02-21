# Deploy a Static Website on AWS S3 using Terraform

## Step 1: Prerequisites

Before you begin, ensure you have the following installed:

- **Terraform** (Download from [terraform.io](https://www.terraform.io/downloads))
- **AWS CLI** (Download from [aws.amazon.com/cli](https://aws.amazon.com/cli/))
- **An AWS account** with appropriate permissions to create S3 buckets and policies.

## Step 2: Initialize Terraform Configuration

Create a new directory for your Terraform project and navigate to it:

```sh
mkdir terraform-s3-static-site
cd terraform-s3-static-site
```

Create a new Terraform file (`main.tf`) and open it in a text editor.

## Step 3: Define the AWS Provider

In `main.tf`, add the AWS provider configuration:

```hcl
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}
```

## Step 4: Create an S3 Bucket

Add the following to `main.tf` to create an S3 bucket for hosting the website:

```hcl
resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-static-website-bucket"  # Replace with a unique bucket name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
```

## Step 5: Upload Website Files

To host a static website, upload `index.html` and `error.html` files:

```hcl
resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "index.html"
  source       = "./index.html"  # Ensure this file exists in your Terraform directory
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_bucket_object" "error" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "error.html"
  source       = "./error.html"
  content_type = "text/html"
  acl          = "public-read"
}
```

## Step 6: Deploy an Online Blog Website

Create an `index.html` file with the following blog template:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Blog</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 40px;
        padding: 20px;
      }
      h1 {
        color: #333;
      }
      .blog-post {
        border-bottom: 1px solid #ccc;
        padding-bottom: 20px;
        margin-bottom: 20px;
      }
    </style>
  </head>
  <body>
    <h1>Welcome to My Blog</h1>
    <div class="blog-post">
      <h2>First Post</h2>
      <p>This is my first blog post. Excited to start sharing my thoughts!</p>
    </div>
    <div class="blog-post">
      <h2>Another Day, Another Post</h2>
      <p>Writing more content to keep my readers engaged. Stay tuned!</p>
    </div>
  </body>
</html>
```

Create an `error.html` file with the following content:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Page Not Found</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        text-align: center;
        padding: 50px;
      }
      h1 {
        font-size: 50px;
        color: red;
      }
      p {
        font-size: 20px;
      }
    </style>
  </head>
  <body>
    <h1>404</h1>
    <p>Oops! The page you are looking for does not exist.</p>
  </body>
</html>
```

## Step 7: Apply the Terraform Configuration

1. Initialize Terraform:

   ```sh
   terraform init
   ```

2. Plan the changes:

   ```sh
   terraform plan
   ```

3. Apply the changes:
   ```sh
   terraform apply -auto-approve
   ```

## Step 8: Access the Static Website

After deployment, retrieve the website URL using:

```sh
echo "http://$(terraform output website_url)"
```

Or manually check the website URL in AWS:

```
http://my-static-website-bucket.s3-website-us-east-1.amazonaws.com
```

Replace `my-static-website-bucket` with your actual bucket name.

```
http://static-website-demo-28bc7c3cb3.s3-website-us-east-1.amazonaws.com/
```

![alt text](image.png)
![alt text](image-1.png)

## Step 9: Cleanup (Optional)

If you no longer need the S3 website, destroy the resources:

```sh
terraform destroy -auto-approve
```

## Conclusion

You have successfully deployed a static website on AWS S3 using Terraform! 🎉

For further customization, consider using **CloudFront** for CDN caching and **Route 53** for a custom domain name.

---

# Final Code

1. Create `variables.tf` file

```sh
touch variables.tf
```

```hcl
# AWS PROVIDER
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.88.0"
    }
    # Random Provider
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
  # BACKEND BLOCK
  backend "s3" {
    bucket = "my-bucket-e3fd3e6050"
    key = "backend.tfstate"
    region = "us-east-1"

  }
}



# REGION VARIABLE
variable "aws_region" {
  description = "AWS_REGION to create AWS resources"
  type = string
  default = "us-east-1"
}

# INSTANCE_TYPE_VARIABLE
variable "aws_instance_type" {
  description = "Instance Type to create AWS EC2 INSTANCES"
  type = string
  default = "t2.micro"

}

# AWS UBUNTU AMI VARIABLE
variable "AWS_UBUNTU_AMI" {
  description = "UBUNTU IMAGE AMI"
  type = string
  default = "ami-04b4f1a9cf54c11d0"

}

# AWS AMAZON LINUX AMI
variable "AWS_AMAZON_LINUX_AMI" {
  description = "Amazon Linux AMI"
  type = string
  default = "ami-053a45fff0a704a47"

}

variable "INSTANCE_NAME" {
  description = "Instance name and tag"
  default = {
    Name = "terraform-app-server"
  }

}

```

---

2. Create `main.tf` file

```sh
touch main.tf
```

```
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


```

---

3.terraform( init, validate, plan, apply)

```
terraform init
terraform validate
terraform plan
terraform apply
```

```
http://static-website-demo-28bc7c3cb3.s3-website-us-east-1.amazonaws.com/
```

![alt text](image.png)
![alt text](image-1.png)

---
