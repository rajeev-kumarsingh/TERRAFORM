# VPC ID
output "aws_vpc_id" {
  description = "AWS VPC ID TO CREATE INSTANCE AND OTHER RESOURCES"
  value = aws_vpc.my_vpc.id
  
}

# Public Subnet ID
output "my_vpc_public_subnet_id" {
  description = "Public Subnet ID"
  value = aws_subnet.my_vpc_public_subnet.id
}

# Private Subnet ID
output "my_vpc_private_subnet_id" {
  description = "Private Subnet ID"
  value = aws_subnet.my_vpc_private_subnet.id
}

# Internet Gateway ID
output "my_vpc_igw_id" {
  description = "Internet Gateway ID"
  value = aws_internet_gateway.my_vpc_igw.id
}

# ROUTE TABLE ID
output "route_table_id" {
  description = "ROUTE TABLE ID"
  value = aws_vpc.my_vpc.main_route_table_id
  
}


# allow_ssh
output "my_vpc_security_group_allow_ssh" {
  description = "allow_ssh security group id"
  value       = aws_security_group.my_vpc_sg.id
}

# allow_http
output "my_vpc_security_group_allow_http" {
  description = "allow_http security group id"
  value       = aws_security_group.allow_http.id
}


# EC2 ID
output "nginx_ec2_machine_id" {
  description = "EC2 Machine ID"
  value = aws_instance.nginx-ec2-machine.id
}

# EC2 Public IP
output "nginx_ec2_machine_public_ip" {
  description = "EC2 machine public IP"
  value = aws_instance.nginx-ec2-machine.public_ip
  
}

# EC2 Private IP
output "nginx_ec2_machine_private_ip" {
  description = "EC2 machine private IP"
  value = aws_instance.nginx-ec2-machine.private_ip
  
}


# Output the full HTTP URL to access the NGINX server
output "nginx-ec2-machine-url" {
  description = "Access the NGINX Web Server"
  value = "http://${aws_instance.nginx-ec2-machine.public_ip}"
  
}