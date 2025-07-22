# PUBLIC KEY FILE NAME
output "key_name" {
  value = aws_key_pair.imported.key_name

}
# PRIVATE KEY FILE NAME
output "pem_file" {
  value = local_file.private_key_pem.filename

}
# SSH ACCESS SECURITY GROUP ID
output "aws_security_group_ssh-id" {
  description = "SSH security group id"
  value       = aws_security_group.ingress-ssh.id

}
# WEB ACCESS 80 AND 443 SECURITY GROUP IP
output "aws_security_group_http_https-id" {
  description = "HTTP/HTTPS security group id "
  value       = aws_security_group.vpc-web.id

}
# VPC PING SECURITY GROUP ID
output "aws_security_group_vpc_ping" {
  description = "vpc-ping security group id"
  value       = aws_security_group.vpc-ping.id
}
# VPC ID
output "vpc_id" {
  value = data.aws_vpc.vpc_id.id
}

# Public IP 
output "ubuntu-server-public-ip" {
  description = "Ubuntu Server Public IP"
  value       = aws_instance.ubuntu-server.public_ip
}
# Private IP
output "ubuntu-server-private-ip" {
  description = "Ubuntu Server Private IP"
  value       = aws_instance.ubuntu-server.private_ip
}
# public_dns
output "public_dns" {
  description = "public_dns"
  value       = aws_instance.ubuntu-server.public_dns

}
output "instance-type" {
  description = "instance-type"
  value       = aws_instance.ubuntu-server.instance_type
}
