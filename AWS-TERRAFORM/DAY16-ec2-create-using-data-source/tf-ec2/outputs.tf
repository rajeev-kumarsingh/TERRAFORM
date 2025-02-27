output "ubuntu_ami_id" {
  description = "Get Ubuntu AMI ID"
  value = data.aws_ami.ubuntu.id
}

# Security Group
output "Security_Group" {
  description = "Get Security Group"
  value = data.aws_security_group.my-sg.id
}

# EC2 Instance ID
output "my_server_id" {
  description = "My server ID"
  value = aws_instance.my_server.id
  
}
# EC2 Public IP
output "my_server_public_ip" {
  description = "Public IP"
  value = aws_instance.my_server.public_ip
}
# EC2 Private IP
output "my_server_private_ip" {
  description = "Private IP"
  value = aws_instance.my_server.private_ip
  
}