resource "aws_instance" "my_server" {
  ami = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [data.aws_security_group.my-sg.id] # Use `.id` for VPC-based SGs
  instance_type = "t2.micro"

  
}