
# 🚀 Terraform GitHub Provider Example

This guide provides a complete working example of how to use the GitHub provider in Terraform securely and efficiently.

---

## ✅ Prerequisites

- Terraform installed
- GitHub Personal Access Token (PAT) with scopes like `repo`, `admin:repo_hook`
- (Optional) GitHub Organization access if managing org resources

---

## 🔐 Step 1: Export GitHub Token Securely

Use environment variable to avoid hardcoding:

```bash
export TF_VAR_github_token="your_token_here"
```

---

## 🛠️ Step 2: Terraform Configuration

### `main.tf`

```hcl
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = "rajeev-kumarsingh"
}
```

---

### `variables.tf`

```hcl
variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}
```

---

### `repository.tf`

```hcl
resource "github_repository" "demo" {
  name        = "demo-repo"
  description = "Created with Terraform"
  visibility  = "private"
  auto_init   = true
}
```

---

## 🧪 Step 3: Initialize & Apply

```bash
terraform init
terraform plan
terraform apply
```

---

## 📌 Notes

- Do **not hardcode** secrets in `.tf` files.
- You can import an existing repo using:

```bash
terraform import github_repository.demo existing-repo-name
```

- Use `.gitignore` to exclude `.terraform/` and `.tfstate` files.

---

## 🔒 Security Tips

- Revoke leaked tokens immediately at: https://github.com/settings/tokens
- Rotate tokens regularly
- Prefer environment variables or secret managers (like Vault)

---
