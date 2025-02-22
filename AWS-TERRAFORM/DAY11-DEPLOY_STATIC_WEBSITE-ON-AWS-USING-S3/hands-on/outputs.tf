# For list S3 Objects
output "aws_s3_object" {
  description = "List Bucket Objects"
  value = aws_s3_bucket.demo-website.id
  
}
# Output the Website URL Add this to get the S3 static website URL:

#output "website_url" {
  #value = "http://${aws_s3_bucket.demo-website.website_endpoint}"
#}
output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}
