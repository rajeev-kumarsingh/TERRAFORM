
# Terraform Modules - Complete Guide with Real-World Example

## 📘 What is a Terraform Module?

A **Terraform module** is a container for multiple resources that are used together. It is the **fundamental unit of code reuse** in Terraform.

> "Any Terraform configuration file (.tf) in a directory is a module."

There are two types of modules:
1. **Root Module** – The directory where you run `terraform init` and `terraform apply`
2. **Child Module** – Any module that is called from the root module or other modules

---

## 🧱 Why Use Modules?

- Reusability
- Maintainability
- Consistency across environments
- Easier collaboration in teams
- Better organization

---

## 🧪 Basic Module Structure

A typical module consists of:
- `main.tf`: Resources
- `variables.tf`: Inputs
- `outputs.tf`: Outputs
- `terraform.tfvars`: Variable values (optional)

Example directory layout:

```
project/
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

---

## 🔍 How to Use a Module

```hcl
module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  environment = "dev"
}
```

- `source`: Path or registry location of the module
- Variables like `cidr_block` and `environment` are passed to the module

---

## 🌐 Remote Modules from Terraform Registry

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  ...
}
```

This pulls an existing VPC module from the Terraform Registry and provisions AWS infrastructure.

---

## ✅ Real-World Example: VPC + Subnets + EC2

### Directory Layout

```
infra/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── modules/
│   ├── vpc/
│   ├── subnet/
│   └── ec2/
```

### main.tf (Root module)

```hcl
module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = var.vpc_cidr
}

module "subnet" {
  source         = "./modules/subnet"
  vpc_id         = module.vpc.vpc_id
  subnet_cidrs   = var.subnet_cidrs
}

module "ec2" {
  source      = "./modules/ec2"
  subnet_id   = module.subnet.public_subnet_id
  instance_type = var.instance_type
}
```

---

## 🧮 Inputs and Outputs

### variables.tf in module

```hcl
variable "cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}
```

### outputs.tf in module

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

These allow **data flow into and out of the module**.

---

## 🛠 Best Practices

- Use modules for all major components (VPC, EC2, RDS, etc.)
- Version your modules
- Keep modules small and single-purpose
- Avoid hardcoding values
- Document all inputs/outputs

---

## 📦 Publish Your Own Module

You can publish modules to:
- Terraform Registry (public)
- GitHub/GitLab repos (source-based)
- Private module registries (for orgs using Terraform Cloud/Enterprise)

---

## 🔚 Conclusion

Terraform modules help you write cleaner, reusable, scalable, and maintainable code. Mastering modules is **key to managing large-scale infrastructure**.

---

## 📚 References

- [Terraform Modules Documentation](https://developer.hashicorp.com/terraform/language/modules)
- [Terraform AWS Modules Registry](https://registry.terraform.io/namespaces/terraform-aws-modules)
- [Writing Modules Guide](https://developer.hashicorp.com/terraform/language/modules/develop)
