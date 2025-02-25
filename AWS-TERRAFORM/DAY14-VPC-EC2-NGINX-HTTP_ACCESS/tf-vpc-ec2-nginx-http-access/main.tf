# 1. Name tag/ Name of the VPC
# 2. IPv4 CIDR block , if you want to use IPV6 then write IPV4 CIDR block
# 3. Tenancy
# 4. Tags
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "my_vpc"
    Environment = "test"
    Tool = "terraform"
  }
  
}
