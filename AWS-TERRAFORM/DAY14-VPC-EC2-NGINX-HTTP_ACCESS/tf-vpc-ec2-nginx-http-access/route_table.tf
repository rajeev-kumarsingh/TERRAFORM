# Terraform resource to update main route table
resource "aws_route" "main_route_table" {
  route_table_id = aws_vpc.my_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_vpc_igw.id
}