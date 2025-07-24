resource "aws_instance" "ec2_server" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-0eafdc0f2a29857ad"
  associate_public_ip_address = true

  tags = {
    Name = "ec2-server"
  }
}
