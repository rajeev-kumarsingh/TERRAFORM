# Terraform Input Variables

## 📘 What Are Input Variables?

Input variables in Terraform are used to parameterize configurations. This allows you to write flexible and reusable code by avoiding hardcoding values directly into your resources.

---

## 🧱 Syntax of Input Variables

```hcl
variable "variable_name" {
  description = "A brief description of the variable"
  type        = string    # or number, bool, list, map, object, etc.
  default     = "default value"
}
```

---

## 🔗 Example: Using Input Variables

### ✅ Step 1: Define Variables

Create a file named `variables.tf`:

```hcl
variable "region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
```

---

### ✅ Step 2: Use Variables

In your `main.tf` file:

```hcl
provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # example AMI
  instance_type = var.instance_type
}
```

---

### ✅ Step 3: Override Defaults

You can override default values in three ways:

#### 1. Using `terraform.tfvars` file:

```hcl
region        = "us-west-2"
instance_type = "t3.micro"
```

#### 2. Using CLI option:

```bash
terraform apply -var="region=us-west-2" -var="instance_type=t3.micro"
```

#### 3. Using environment variables:

```bash
export TF_VAR_region="us-west-2"
export TF_VAR_instance_type="t3.micro"
```

---

## ✅ Best Practices

- Always include a description.
- Use type constraints for better validation.
- Avoid hardcoding sensitive values—use input variables and secrets management tools.

---

## 🧪 Type Constraints Example

```hcl
variable "allowed_instance_types" {
  type    = list(string)
  default = ["t2.micro", "t3.micro", "t3a.micro"]
}
```

---

## 🔒 Validation Rules Example

```hcl
variable "instance_count" {
  type = number

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 5
    error_message = "Instance count must be between 1 and 5."
  }
}
```

---

## 📄 Summary

| Feature             | Description                                       |
|---------------------|---------------------------------------------------|
| Default Value       | Optional. Provides a fallback                     |
| Type                | Enforces data type (string, list, etc.)           |
| Description         | Helpful metadata                                  |
| Validation          | Adds rules to accept/reject values                |

---

## 📚 Resources

- [Terraform Input Variables Docs](https://developer.hashicorp.com/terraform/language/values/variables)
