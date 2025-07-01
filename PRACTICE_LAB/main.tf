resource "aws_instance" "web" {
  ami = var.amazon_machine_image
  instance_type = "t2.micro"
  key_name = "866134557404_public_key"
  vpc_security_group_ids = ["sg-0b23952fd5885850a"]
  tags = {
    Name = "Ubuntu-machine"
  }
  }
  
