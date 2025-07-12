
# Terraform: Deploying Public Subnets Dynamically Using `for_each`

This file explains how to deploy **public subnets** dynamically using `for_each` in Terraform, similar to private subnets.

---

## 🧱 Example Terraform Code

```hcl
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
```

---

## 🔹 Input Variable Example

```hcl
variable "public_subnet" {
  default = {
    "public-subnet-1" = 0
    "public-subnet-2" = 1
    "public-subnet-3" = 2
  }
}
```

This allows you to create subnets named `public-subnet-1`, `public-subnet-2`, and `public-subnet-3`, each in a different AZ with a unique CIDR block.

---

## 🔹 Explanation

### `for_each = var.public_subnet`

- Iterates over the map.
- `each.key` → Name tag of subnet
- `each.value` → Index for AZ and CIDR generation

---

### `vpc_id = aws_vpc.vpc.id`

Links each subnet to the specified VPC.

---

### `cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value)`

Generates a unique /24 subnet for each:

- `cidrsubnet("10.0.0.0/16", 8, 0)` → `10.0.0.0/24`
- `cidrsubnet("10.0.0.0/16", 8, 1)` → `10.0.1.0/24`

---

### `availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]`

Distributes subnets across availability zones by index.

> Requires this data source:
```hcl
data "aws_availability_zones" "available" {}
```

---

### `map_public_ip_on_launch = true`

Enables auto-assignment of public IPs to instances in this subnet.

---

### `tags = { Name = each.key }`

Applies a tag like `"Name" = "public-subnet-1"` for each subnet.

---

## ✅ Result

Creates 3 public subnets, each:
- In a different AZ
- With a distinct CIDR block
- With public IPs enabled

---

## 📚 Resources

- [Terraform aws_subnet resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Terraform cidrsubnet function](https://developer.hashicorp.com/terraform/language/functions/cidrsubnet)
- [AWS Availability Zones Data Source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)
