
# Resouce to create VPC ONLY
# Steps
# 1. Name tag/ Name of the VPC
# 2. IPv4 CIDR block , if you want to use IPV6 then write IPV4 CIDR block
# 3. Tenancy
# 4. Tags

resource "aws_vpc" "tf-vpc" {
  
  # Define IPV4 CIDR 
  cidr_block = "10.0.0.0/16"
  # Define Tenancy
  instance_tenancy = "default"
  # Define Tags
  tags = {
    Name = "MyDemoVpc"
    Environment = "test"
    Tool = "terraform"
  }
}

