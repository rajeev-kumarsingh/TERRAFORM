# Terraform: Configuring Providers and HCL Syntax

## 🧩 What is a Provider?

A **provider** is a plugin that allows Terraform to interact with APIs of cloud platforms and services like AWS, Azure, GCP, GitHub, Kubernetes, etc.

> Example: The `aws` provider allows Terraform to manage AWS resources.

---

## ⚙️ How to Configure a Provider

In Terraform, provider configuration is done using the `provider` block.

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
```

You also define required providers using the `required_providers` block inside `terraform`.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

## 📘 Provider Resources

Useful links to provider documentation:

- AWS Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Azure Provider Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- GCP Provider Docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs
- Kubernetes Provider Docs: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
- GitHub Provider Docs: https://registry.terraform.io/providers/integrations/github/latest/docs

---

## 🧾 HCL Syntax: HashiCorp Configuration Language

HCL is a declarative language designed specifically for infrastructure-as-code. Below are the core components:

### ✅ 1. Block Syntax

Blocks are the basic unit in HCL and have the form:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

- `resource` → block type
- `"aws_instance"` → resource type
- `"example"` → resource name

---

### ✅ 2. Variables

```hcl
variable "region" {
  type    = string
  default = "us-west-2"
}
```

To use it:

```hcl
provider "aws" {
  region = var.region
}
```

---

### ✅ 3. Outputs

```hcl
output "instance_id" {
  value = aws_instance.example.id
}
```

---

### ✅ 4. Comments

Use `#`, `//`, or `/* */` for comments:

```hcl
# Single line
// Another single line
/* Multi-line
   comment */
```

---

## 🛠 Real-World Example: AWS EC2 Instance

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.region
}

variable "region" {
  default = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "TerraformInstance"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}
```

---

## ✅ Summary

- **Provider** tells Terraform how to connect to the external APIs.
- **HCL** is easy to read and write, designed for infrastructure configuration.
- Use `terraform init` to download the provider.
- Use `terraform apply` to provision resources.