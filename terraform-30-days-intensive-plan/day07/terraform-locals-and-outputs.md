
# Terraform Local Values and Output Values

## 📌 1. Local Values

### ✅ What are Local Values?
Local values in Terraform allow you to name and reuse expressions, making your code cleaner and more maintainable.

### 📖 Syntax

```hcl
locals {
  instance_name = "web-server-${var.environment}"
  tags = {
    Environment = var.environment
    Project     = "TerraformDemo"
  }
}
```

### 💡 Use Case Example

```hcl
variable "environment" {
  default = "dev"
}

locals {
  name_prefix = "myapp-${var.environment}"
}

resource "aws_s3_bucket" "example" {
  bucket = "${local.name_prefix}-bucket"
  acl    = "private"
}
```

### ✅ Why Use Locals?

- Reduce repetition
- Improve readability
- Store computed values

---

## 📌 2. Output Values

### ✅ What are Output Values?
Output values are used to print information after `terraform apply` and share data between modules.

### 📖 Syntax

```hcl
output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
```

### 🧪 Example

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"
  acl    = "private"
}

output "bucket_id" {
  value = aws_s3_bucket.example.id
}
```

### 💡 Use Cases

- Debugging
- Sharing info between modules
- Displaying infrastructure details (IP, URL, etc.)

---

## 📚 Real-World Example

```hcl
variable "project_name" {
  default = "devopsgyan"
}

variable "env" {
  default = "prod"
}

locals {
  full_name = "${var.project_name}-${var.env}"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = local.full_name
  }
}

output "instance_name" {
  value = local.full_name
}

output "instance_id" {
  value = aws_instance.example.id
}
```

---

## 🧠 Tips

- Local values **do not persist** outside the module.
- Output values **can be used** to pass data across modules.
- Both are **purely Terraform constructs** — no impact on real resources.

---

## 📎 Resources

- [Terraform Locals Documentation](https://developer.hashicorp.com/terraform/language/values/locals)
- [Terraform Output Documentation](https://developer.hashicorp.com/terraform/language/values/outputs)
