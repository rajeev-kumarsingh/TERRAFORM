# Resouces to update Route table
resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.private_route_table.id # Replace with your route table id
  destination_cidr_block = "0.0.0.0/0" # All network
  gateway_id = aws_internet_gateway.MyDemoVpc-IGW.id # Replace with your own internet gateway id
  
}