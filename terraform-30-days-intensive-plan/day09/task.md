# Day-09: Task

[`Resources`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami?product_intent=terraform)

- Task 1: Add a new data source to query the current AWS region being used

```hcl
data "aws_region" "curren"{

}
```

- Task 2: Update the Terraform configuration file to use the new data source

```hcl
# Define the VPC
# VPC Resource Block
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    Environment = var.environment
    Terraform = true
    region = data.aws_region.current.name
  }
}
```

- Task 3: View the data source used to retrieve the availability zones within the region

```hcl
#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
```

- Task 4: Validate the data source is being used in the Terraform configuration file

```hcl
# Public Subnet
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

# Private subnet
resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.vpc.id
  for_each = var.private_subnets
  cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value+100)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  tags = {
    Name = each.key
    Terraform = true
  }
  }

```

- Task 5: Create a new data source for querying a different Ubuntu image

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (Ubuntu)

  tags = {
    Name = "Latest Ubuntu 22.04 LTS"
  }
}

```

- Task 6: Make the aws_instance web_server use the Ubuntu image returned by the data source
-
-
