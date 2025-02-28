# Terraform Modules

## Introduction

Terraform modules are containers for multiple resources that are used together. They help in organizing code, making it reusable, and improving maintainability.

## Root Module vs. Other Modules

### Root Module

- The **root module** is the main directory where Terraform execution begins.
- It contains the primary Terraform configuration files (e.g., `main.tf`, `variables.tf`, `outputs.tf`).

### Child Modules

- **Child modules** are reusable Terraform configurations that can be called from the root module.
- They allow abstraction and modularization of infrastructure code.
- Can be stored locally or remotely (Terraform Registry, GitHub, etc.).

## How Terraform Modules Work

### 1. Root Module (Main Configuration)

The root module defines the main infrastructure setup and calls child modules.

### 2. Using Child Modules

Child modules encapsulate specific infrastructure components like VPCs, EC2 instances, or databases.

## Example: Root Module & Child Modules

### **Project Structure**

```
/terraform-project
│── main.tf
│── variables.tf
│── outputs.tf
│── terraform.tfvars
│── /modules
│   ├── vpc
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── ec2
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
```

### 1. **Define a Child Module (`modules/vpc/main.tf`)**

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}
```

#### **Variables (`modules/vpc/variables.tf`)**

```hcl
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}
```

#### **Outputs (`modules/vpc/outputs.tf`)**

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

### 2. **Using the Child Module in the Root Module (`main.tf`)**

```hcl
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "MyVPC"
}
```

### **Executing Terraform**

1. **Initialize the project**
   ```sh
   terraform init
   ```
2. **Apply the configuration**
   ```sh
   terraform apply -auto-approve
   ```

## Benefits of Using Modules

✅ **Reusability**: Modules allow code reuse across different environments.  
✅ **Scalability**: Easily scale resources using modular configurations.  
✅ **Simplified Management**: Organizing infrastructure code into smaller modules makes it easier to maintain.  
✅ **Collaboration**: Teams can work on separate modules independently.

## Conclusion

- The **root module** is the entry point for Terraform execution.
- **Child modules** allow breaking infrastructure into smaller, reusable components.
- Terraform modules improve efficiency, scalability, and code reusability.
