# Create EC2 instance in myDemoVpc VPC

resource "aws_instance" "web_server" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  #subnet_id = "subnet-02732ba75e2be5cc9" #Replace with your own public subnet ID
  subnet_id = aws_subnet.public_subnet_myDemoVpc.id
  vpc_security_group_ids = [
    aws_security_group.allow_http.id,
    aws_security_group.allow_https.id,
    aws_security_group.allow_ssh.id
    
  ]  # Corrected security group references
  
  # Or
  #vpc_security_group_ids = [
  #aws_security_group.allow_ssh.id,
  #aws_security_group.allow_http.id,
  #aws_security_group.allow_https.id
  #]

  associate_public_ip_address = true

  tags = {
    Name = "web_server"
  }
}