output "aws_ami" {
  description = "Image ID"
  value = data.aws_ami.ubuntu.id
  
}

# Find Security Group by Name
output "security_group_by_name" {
  description = "Security Group"
  value = data.aws_security_group.find-by-name.id
  
}

output "security_group_by_tag" {
  description = "Find security group by tags"
  value = data.aws_security_groups.find-sg-by-tag.id
  
}

# List all availability zones
output "aws_availability_zones" {
  description = "List all availability zones"
  value = data.aws_availability_zones.available.names
  
}

# Select a Specific Availability Zone
output "first_az" {
  description = "Select First AZ"
  value = data.aws_availability_zones.available.names[0] # Get the first AZ
  
}

output "second_az" {
  description = "Select second AZ"
  value = data.aws_availability_zones.available.names[1] # Get the first AZ
  
}

# To retrieve AWS account details using Terraform
# Get AWS Account ID, User, and ARN

# account_id
output "account_id" {
  description = "Get the current account id"
  value = data.aws_caller_identity.current.account_id
  
}

# caller_arn
output "caller_arn" {
  description = "Get the current caller_arn"
  value = data.aws_caller_identity.current.arn
  
}

# caller_user_id
output "caller_user_id" {
  description = "Get the current caller_user_id"
  value = data.aws_caller_identity.current.user_id
  
}
