output "instance_id" {
  description = "Id of the ec2 machine"
  value = aws_instance.web.id

  
}

output "aws_instance_public_IP" {
  description = "Public IP of Ubuntu machine"
  value = aws_instance.web.public_ip
  
}