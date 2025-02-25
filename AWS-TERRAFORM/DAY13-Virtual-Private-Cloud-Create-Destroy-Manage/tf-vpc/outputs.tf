# VPC ID
output "aws_vpc" {
  description = "VPC ID"
  value = aws_vpc.tf-vpc.id
  
}

# Internet gateway ID
output "tf_vpc_igw" {
  description = "Internet Gateway ID"
  value = aws_internet_gateway.MyDemoVpc-IGW.id
  
}

# Route Table public_internet_access
output "public_internet_access" {
  description = "Public Internet Access ID"
  value = aws_route.public_internet_access.id
  
}

output "tf_vpc_route_private_id" {
  description = "private route table id"
  value = aws_route_table.private_route_table.id
  
}

# Nat gateway id
output "tf_vpc_nat_gateway_id" {
  description = "Nat Gateway Id"
  value = aws_nat_gateway.nat_gw.id
  
}

# Security Groups ID allow_http
output "tf_vpc_security_group_allow_http" {
  description = "Security Group ID"
  value = aws_security_group.allow_http.id
  
}
# Security Groups ID allow_ssh
output "tf_vpc_security_group_allow_ssh" {
  description = "ssh security group"
  value = aws_security_group.allow_ssh.id
}

# Security Group ID
output "tf_vpc_security_group_allow_https" {
  description = "https security group"
  value = aws_security_group.allow_https.id
}

# public and private subnet id 
output "tf_vpc_public_subner" {
  description = "Public Subnet ID"
  value = aws_subnet.public_subnet_myDemoVpc.id
}

# Private Subnet ID 
output "tf_vpc_private_subnet_id" {
  description = "Private Subnet ID"
  value = aws_subnet.private_subnet_myDemoVpc.id
}

# EC2 instance public IPV4 Address
output "ec2_instance_public_ip" {
  description = "Ec2 Instamce Public Adderess"
  value = aws_instance.web_server.public_ip
}
# EC2 instance private IP
output "ec2_instance_private_ip" {
  description = "EC2 Instance Private IP"
  value = aws_instance.web_server.private_ip
}

# EC2 Instance ID
output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value = aws_instance.web_server.id
}
