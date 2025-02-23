# If your private subnet needs internet access (e.g., for updates), you need a NAT Gateway.

# Create an Elastic IP (EIP)

resource "aws_eip" "nat" {
  domain = "vpc"
}

# Create the NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnet_myDemoVpc.id
}

# Update the Private Subnet Route Table

#resource "aws_route" "private_nat_access" {
#  route_table_id = var.route-route_table_id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id = aws_nat_gateway.nat_aw.id
#}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}