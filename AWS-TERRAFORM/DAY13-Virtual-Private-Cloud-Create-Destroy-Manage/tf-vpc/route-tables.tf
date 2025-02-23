# Resouces to update Route table
resource "aws_route" "public_internet_access" {
  route_table_id = "rtb-069aeb561f17d1f8a" # Replace with your route table id
  destination_cidr_block = "0.0.0.0/0" # All network
  gateway_id = "igw-06599081680722fa4" # Replace with your own internet gateway id
  
}