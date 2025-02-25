# Create public and private subnets

resource "aws_subnet" "public_subnet_myDemoVpc" {
  vpc_id = aws_vpc.tf-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public_subnet_myDemoVpc"
  }
}
resource "aws_subnet" "private_subnet_myDemoVpc" {
  vpc_id = aws_vpc.tf-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private_subnet_myDemoVpc"
  }
  
}
