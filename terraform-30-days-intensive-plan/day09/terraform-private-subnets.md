
# Terraform: Deploying Private Subnets in AWS

This file explains the following Terraform code that creates private subnets dynamically using `for_each`, `cidrsubnet`, and availability zones.

```hcl
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}
```

---

## 🔹 Resource Block

Defines an AWS subnet resource named `private_subnets`. The use of `for_each` allows dynamic creation of multiple subnets.

### Example Input Variable

```hcl
private_subnets = {
  "private-subnet-1" = 0
  "private-subnet-2" = 1
}
```

---

## 🔹 Line-by-Line Explanation

### `for_each = var.private_subnets`

- Iterates over the map `private_subnets`
- `each.key` → subnet name (e.g., `"private-subnet-1"`)
- `each.value` → index (e.g., `0`, `1`)

---

### `vpc_id = aws_vpc.vpc.id`

Associates each subnet with the specified VPC.

---

### `cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value)`

Generates unique subnet CIDRs based on the VPC range.

If `var.vpc_cidr = "10.0.0.0/16"`:
- `cidrsubnet("10.0.0.0/16", 8, 0)` → `10.0.0.0/24`
- `cidrsubnet("10.0.0.0/16", 8, 1)` → `10.0.1.0/24`

---

### `availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]`

Dynamically assigns each subnet to a different AZ:
- Converts AZ names into a list
- Picks one based on `each.value`

> Requires this data block:
```hcl
data "aws_availability_zones" "available" {}
```

---

### `tags = { Name = each.key, Terraform = "true" }`

Applies tags:
- `Name` → from map key (`"private-subnet-1"`)
- `Terraform` → useful for tracking resources created by Terraform

---

## ✅ Output Example

For input:

```hcl
private_subnets = {
  "private-subnet-1" = 0
  "private-subnet-2" = 1
}
```

The result will be:
- Subnet 1: `10.0.0.0/24`, `us-east-1a`
- Subnet 2: `10.0.1.0/24`, `us-east-1b`

Both are tagged and created within the same VPC.

---

## 📚 Resources

- [Terraform cidrsubnet function](https://developer.hashicorp.com/terraform/language/functions/cidrsubnet)
- [AWS Subnet Terraform Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [AWS Availability Zones Data Source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)
