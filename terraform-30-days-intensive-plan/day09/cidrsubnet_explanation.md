# Explanation of `cidrsubnet(var.vpc_cidr, 8, each.value + 100)`

This expression is used in Terraform to generate a subnet CIDR block from a base VPC CIDR block.

### Expression:

```hcl
cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
```

### Components:

1. **`cidrsubnet()`**:

   - A Terraform function that calculates subnet CIDR blocks based on a given CIDR prefix.
   - Syntax: `cidrsubnet(iprange, newbits, netnum)`

2. **`var.vpc_cidr`**:

   - This is a variable that holds the CIDR block of the VPC (e.g., `"10.0.0.0/16"`).

3. **`8` (newbits)**:

   - This indicates the number of additional bits to add to the prefix length of the base CIDR block.
   - If `var.vpc_cidr` is `"10.0.0.0/16"`, adding 8 bits gives `"10.0.0.0/24"` subnets.

4. **`each.value + 100` (netnum)**:
   - This determines which subnet to select from the possible subnets created by adding the new bits.
   - Adding 100 offsets the index, possibly to avoid overlapping with previously defined subnets.

### Example:

If `var.vpc_cidr = "10.0.0.0/16"` and `each.value = 1`:

- `cidrsubnet("10.0.0.0/16", 8, 101)` results in `"10.0.101.0/24"`

This way, each subnet generated will be a unique `/24` subnet under the `10.0.0.0/16` VPC CIDR block, starting from index 100.

### Use Case:

This pattern is commonly used when dynamically creating subnets inside a VPC using loops or `for_each`, especially when you want to separate them cleanly and avoid overlapping CIDR blocks.

---

# Simplest way of explanation

# 🧠 Understanding the cidrsubnet Function

The cidrsubnet function is used in Terraform to create new subnet CIDRs from a larger base CIDR block.

## 🔹 Syntax:

```hcl
cidrsubnet(base_cidr_block, new_bits, netnum)
```

| Argument          | Meaning                                                           |
| ----------------- | ----------------------------------------------------------------- |
| `base_cidr_block` | The original network block (e.g., 10.0.0.0/16)                    |
| `new_bits`        | How many additional bits to add to create subnets (e.g., 8 → /24) |
| `netnum`          | Which subnet number to generate (like an index)                   |

## ✅ Your Code:

```hcl
cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value + 100)

```

### 🔍 Explanation:

- `var.vpc_cidr`: This is the base VPC CIDR block (e.g., "10.0.0.0/16").
- `8`: You are dividing the /16 block into smaller /24 subnets.
- `each.value + 100`: You're starting subnet numbering from 100, not from 0.
  > If each.value = 0, then netnum = 100

> If each.value = 1, then netnum = 101

This **offsets** the subnet ranges so that:

- You don’t overlap with previously defined subnets (e.g., private subnets that used `0–50`)
- You create a distinct range for specific use (e.g., **public**, **database**, or **isolated** subnets)

## 🔢 Example

Let’s assume:

```hcl
var.vpc_cidr = "10.0.0.0/16"

```

Then:
| `each.value` | `each.value + 100` | Generated Subnet |
| ------------ | ------------------ | ---------------- |
| 0 | 100 | `10.0.100.0/24` |
| 1 | 101 | `10.0.101.0/24` |
| 2 | 102 | `10.0.102.0/24` |

## ✅ Summary

The use of + 100:

- Prevents CIDR overlap
- Helps organize subnets by range
- Is commonly used for **environment** **separation**, e.g., `dev`, `prod`, `database`
