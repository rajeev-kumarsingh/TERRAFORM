# Terraform Variables - A Step-by-Step Guide

## Introduction

Terraform variables allow you to parameterize configurations, making them more flexible and reusable. This guide will cover the different types of variables, how to define and use them, and an example to demonstrate their usage.

## Types of Variables

Terraform supports three types of variables:

1. **String** - Holds a sequence of characters.
2. **Number** - Stores numeric values (integers or floats).
3. **Boolean** - Represents `true` or `false` values.
4. **List** - A collection of values in an ordered sequence.
5. **Map** - A collection of key-value pairs.
6. **Object** - A complex type with multiple attributes.
7. **Tuple** - A fixed-length sequence of values of different types.

## Defining Variables

### 1. Using `variable` Block

Variables are defined in a `.tf` file using the `variable` block.

```hcl
variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
```

### 2. Using `terraform.tfvars` File

A separate file, `terraform.tfvars`, can be used to provide values for variables.

```hcl
instance_type = "t3.medium"
```

### 3. Using Environment Variables

You can also set variable values using environment variables:

```sh
export TF_VAR_instance_type="t3.large"
```

## Using Variables

Once defined, variables can be used in Terraform configuration files.

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}
```

## Example - Complete Implementation

Let's create a simple Terraform configuration using variables.

### Step 1: Define Variables in `variables.tf`

```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
```

### Step 2: Create `terraform.tfvars`

```hcl
instance_type = "t3.micro"
```

### Step 3: Write the Main Configuration in `main.tf`

```hcl
provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}
```

### Step 4: Initialize and Apply Terraform

```sh
terraform init
terraform apply -auto-approve
```

## Special Variable File Formats

### 1. `*.out.vars`

Terraform can generate output variables and save them to a file, typically in JSON format. This is useful for automation and passing outputs between Terraform runs.

```sh
echo '{"instance_id":"i-1234567890abcdef0"}' > terraform.out.vars
```

You can use this file later by parsing it with tools like `jq` or passing it to another Terraform module.

### 2. `-vars-*` File Naming Convention

Files that include `-vars-` in their names are commonly used to store variable values in Terraform projects. For example, `prod-vars.tfvars` or `dev-vars.tfvars` can be used for different environments.

```sh
terraform apply -var-file=prod-vars.tfvars
```

This approach allows easy switching between different configurations without modifying the main Terraform code.

## Use Cases in a Live Environment

1. **Multi-Environment Deployment**: Use different variable files (`dev-vars.tfvars`, `prod-vars.tfvars`) to manage multiple environments seamlessly.
2. **Dynamic Resource Allocation**: Define variables for instance types, region, and number of instances to easily adjust infrastructure configurations.
3. **Secret Management**: Store sensitive information like API keys and database credentials using environment variables or encrypted `.tfvars` files.
4. **Scalability and Reusability**: Use modules with variables to create reusable Terraform configurations applicable across multiple projects.
5. **Automation and CI/CD Pipelines**: Pass variables dynamically through Terraform commands in CI/CD pipelines to enable automated deployments.
6. **Infrastructure Cost Optimization**: Adjust resource sizes dynamically using variables to optimize cloud costs based on real-time requirements.
7. **Team Collaboration**: Standardize configurations by defining shared variable files, making infrastructure code more manageable and predictable.

## Best Practices

- Always provide descriptions for variables.
- Use `terraform.tfvars` or environment variables for sensitive data.
- Group variables in a separate `variables.tf` file for better readability.
- Use `locals` for computed values instead of variables when applicable.

## Conclusion

Terraform variables provide flexibility and modularity in infrastructure as code. By defining variables properly, you can create reusable and scalable Terraform configurations.
