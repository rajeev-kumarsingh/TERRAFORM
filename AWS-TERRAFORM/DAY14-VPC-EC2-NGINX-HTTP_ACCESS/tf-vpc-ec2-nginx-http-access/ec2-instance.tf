resource "aws_instance" "nginx-ec2-machine" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_vpc_public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.my_vpc_sg.id, aws_security_group.allow_http.id
    
  ]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

 
  tags = {
    Name = "nginx-ec2-machine"
  }
  
}