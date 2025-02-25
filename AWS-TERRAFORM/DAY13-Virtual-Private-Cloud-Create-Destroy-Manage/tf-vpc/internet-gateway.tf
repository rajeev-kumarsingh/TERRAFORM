# If your public subnets needs internet access, attach an internet gateway to your vpc

resource "aws_internet_gateway" "MyDemoVpc-IGW" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "MyDemoVpc-IGW"
  }
  
}