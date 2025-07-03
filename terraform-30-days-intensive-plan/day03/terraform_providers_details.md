# Terraform Providers in Detail

## 🌐 What is a Terraform Provider?

A **Terraform Provider** is a plugin that allows Terraform to interact with APIs of external platforms like AWS, Azure, GitHub, Kubernetes, Docker, etc.

- Each provider is responsible for understanding **API interactions and exposing resources**.
- Providers are written and maintained by **HashiCorp** or by the **community**.

---

## 🔧 How Providers Work

When you declare a provider in your configuration, Terraform:

1. Downloads the required provider binary.
2. Authenticates using the credentials you provide.
3. Communicates with the platform's API to create/update/delete resources.

---

## ✅ Provider Block Syntax

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
}
```

### 🔹 Key Fields

- `source`: Where to fetch the provider from (usually `hashicorp/<provider_name>`).
- `version`: Pin or constrain the version.
- Provider block: Configure the provider with credentials, region, etc.

---

## 🔍 Common Providers with Examples

### 1. AWS Provider

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

➡️ Creates an EC2 instance in AWS.

---

### 2. Azure Provider

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}
```

➡️ Creates a resource group in Azure.

---

### 3. Google Cloud Provider

```hcl
provider "google" {
  project     = "my-gcp-project"
  region      = "us-central1"
  credentials = file("account.json")
}

resource "google_compute_instance" "default" {
  name         = "vm-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
```

➡️ Launches a GCP VM instance.

---

### 4. GitHub Provider

#### GitHub Terraform block

`step:1`

```hcl
terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "~> 5.0"
    }
  }

}
```

### Instead of hardcoding the GitHub token, use an environment variable:

`Step:2`

### Add variable Block(if using var.github_token):

```hcl
variable "github_token" {
  description = "GitHub persional access token"
  type = string
  sensitive = true


}
```

`Step: 3`

### Use environment variable to set token (recommended):

```bash
export TF_VAR_github_token="your_token_here"

```

`Step: 4`

### Now you can add resources, for example:

```hcl
provider "github" {
  token = var.github_token
  owner = "your-org"
}

resource "github_repository" "example" {
  name        = "my-repo"
  description = "Managed by Terraform"
  private     = true
}
```

➡️ Creates a private GitHub repository.

---

### 5. Kubernetes Provider

```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}
```

➡️ Creates a Kubernetes namespace.

---

## 🔁 Multiple Providers and Aliases

```hcl
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

resource "aws_instance" "east" {
  provider = aws.us_east
  ami      = "ami-east"
  instance_type = "t2.micro"
}

resource "aws_instance" "west" {
  provider = aws.us_west
  ami      = "ami-west"
  instance_type = "t2.micro"
}
```

---

## ⚠️ Tips and Best Practices

- Always pin the version of a provider to prevent unexpected updates.
- Use environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) instead of hardcoding secrets.
- Use **`terraform init`** to install providers.
- Use **`terraform providers`** command to view required and installed providers.

---
