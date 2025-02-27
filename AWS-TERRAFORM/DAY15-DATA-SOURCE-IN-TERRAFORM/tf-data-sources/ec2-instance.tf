resource "aws_instance" "web_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [data.aws_security_group.find-by-name.name]

  tags = {
    Name = "Web_server"
  }
  
}