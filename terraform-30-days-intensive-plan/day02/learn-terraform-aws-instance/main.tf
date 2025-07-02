provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app-server" {
  ami             = data.aws_ami.ubuntu.id #"ami-020cba7c55df1f615" # Amazon Linux UBUNTU
  instance_type   = "t2.micro"
  key_name        = "866134557404_public_key"
  security_groups = [aws_security_group.allow_http_ssh.name]

  tags = {
    Name = "TerraformAppServer"
  }
}

# use data blocks to query your cloud provider for information about other resources.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical's official Ubuntu AMIs
  
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow SSH and HTTP"
  vpc_id      = "vpc-00708b1665b7af592"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "allow_http_ssh"
  }


}