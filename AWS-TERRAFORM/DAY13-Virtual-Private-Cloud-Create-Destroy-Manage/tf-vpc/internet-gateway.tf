# If your public subnets needs internet access, attach an internet gateway to your vpc

resource "aws_internet_gateway" "MyDemoVpc-IGW" {
  vpc_id = "vpc-0ac7845439ce57321"
  tags = {
    Name = "MyDemoVpc-IGW"
  }
  
}