# TO GET INSTANCE ID 
output "instance_id" {
  description = "Get tf_backend server EC2 instance id"
  value = aws_instance.tf-backend.id
  
}

# TO GET PUBLIC IP OF EC2 INSTANCE
output "instance_public_ip" {
  description = "Get public ip of tf_backend server"
  value = aws_instance.tf-backend.public_ip
  
}

# TO GET PRIVATE IP OF EC2 INSTANCE
output "instance_private_ip" {
  description = "Get private ip of tf_backend server"
  value = aws_instance.tf-backend.private_ip
  
}

# TO GET SUBNET GROUP
output "instance_subnet_id" {
  description = "Instance subnet Id of tf_backend server"
  value = aws_instance.tf-backend.subnet_id
  
}

# list objects in an S3 buckets
output "s3_objects" {
  description = "List of objects in the S3 bucket"
  value       = data.aws_s3_objects.tf_backend.keys
}