data "aws_ami" "ubuntu" {
  most_recent = true # Ensure we get the latest AMI version
  owners = ["099720109477"] # Canonical (Official Ubuntu AMI owner ID)

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  
}

data "aws_security_group" "my-sg" {
  name = "22-80-443-sg"
}

