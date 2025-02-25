# Public Subnet
resource "aws_subnet" "my_vpc_public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "my_vpc_public_subnet"
  }
}

# Private Subnet
resource "aws_subnet" "my_vpc_private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "my_vpc_private_subnet"
  }
  
}