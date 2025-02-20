# **Step-by-Step Terraform Configuration with Examples**

Terraform is an Infrastructure as Code (IaC) tool that allows you to define, provision, and manage cloud resources efficiently. This guide provides a **detailed, step-by-step Terraform configuration** with examples.

---

## **1. Install Terraform**

### **MacOS (Using Homebrew)**

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### **Verify Installation**

```sh
terraform -v
```

Expected output:

```
Terraform v1.6.0
```

---

## **2. Create a Terraform Configuration File**

Terraform configuration files use the `.tf` extension and define cloud resources.

### **Example: Create a `main.tf` File**

This example provisions an **AWS EC2 instance**.

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux AMI
  instance_type = "t2.micro"

  tags = {
    Name = "MyTerraformInstance"
  }
}
```

---

## **3. Initialize Terraform**

```sh
terraform init
```

Expected output:

```
Initializing provider plugins...
Terraform has been successfully initialized!
```

---

## **4. Format & Validate Terraform Code**

```sh
terraform fmt  # Formats the code properly
terraform validate  # Checks for errors
```

Expected output:

```
Success! The configuration is valid.
```

---

## **5. Plan Infrastructure Changes**

```sh
terraform plan
```

Sample output:

```
Plan: 1 to add, 0 to change, 0 to destroy.
```

---

## **6. Apply Terraform Configuration**

```sh
terraform apply
```

Terraform will ask for confirmation:

```
Do you want to perform these actions? Type 'yes' to continue.
```

Type `yes` and hit **Enter**.

---

## **7. Verify the Created Resource**

```sh
terraform show
```

---

## **8. Destroy Infrastructure**

```sh
terraform destroy
```

Type `yes` to confirm.

---

## **9. Using Terraform Variables**

### **Define Variables in `variables.tf`**

```hcl
variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}
```

### **Modify `main.tf` to Use Variables**

```hcl
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name = "MyTerraformInstance"
  }
}
```

### **Pass Variables via CLI**

```sh
terraform apply -var="aws_region=us-west-2" -var="instance_type=t3.small"
```

---

## **10. Using Terraform State**

### **Check State**

```sh
terraform state list
```

### **Manually Inspect State**

```sh
terraform show terraform.tfstate
```

---

## **11. Remote Backend for State Management**

Modify `main.tf`:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
```

Run:

```sh
terraform init
```

---

## **12. Use Terraform Modules for Reusability**

### **Create a Module**

Inside the project, create `modules/ec2_instance/main.tf`:

```hcl
resource "aws_instance" "module_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
```

### **Define Module Variables**

Create `modules/ec2_instance/variables.tf`:

```hcl
variable "ami" {}
variable "instance_type" {}
variable "instance_name" {}
```

### **Use the Module in `main.tf`**

```hcl
module "my_instance" {
  source        = "./modules/ec2_instance"
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  instance_name = "MyInstanceFromModule"
}
```

Apply the changes:

```sh
terraform apply
```

---

## **13. Managing Multiple Environments (Dev, Staging, Prod)**

Create separate environment folders:

```
terraform-project/
  ├── dev/
  │   ├── main.tf
  │   ├── variables.tf
  │   └── terraform.tfvars
  ├── staging/
  │   ├── main.tf
  │   ├── variables.tf
  │   └── terraform.tfvars
  ├── prod/
  │   ├── main.tf
  │   ├── variables.tf
  │   └── terraform.tfvars
```

Run Terraform in a specific environment:

```sh
cd dev
terraform apply -var-file="terraform.tfvars"
```

---

## **14. Terraform Best Practices**

✅ **Use Version Control (Git)**: Store your Terraform files in Git.  
✅ **Use Remote State**: Avoid local state storage for team collaboration.  
✅ **Keep Terraform DRY**: Use modules to avoid duplication.  
✅ **Use Workspaces**: Terraform workspaces help manage multiple environments.  
✅ **Use CI/CD for Terraform**: Automate infrastructure deployment.

---

## **15. Terraform with CI/CD**

Use Terraform in **GitHub Actions, CircleCI, or Jenkins** to automate infrastructure provisioning.

Example GitHub Actions workflow:

```yaml
name: Terraform CI

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Install Terraform
        uses: hashicorp/setup-terraform@v1

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan

      - name: Terraform Apply
        run: terraform apply -auto-approve
```

---

## **Conclusion**

This guide covered Terraform from **basic setup to advanced concepts** like **variables, modules, remote state, multiple environments, and CI/CD integration**.

#

#

# Terraform support json format as well

- HCL(Hashicorp Language)

```
provide "aws" {
  region = "us-east-1"
}
```

- json

```
"provider""{
"aws":{
"region" = "us-east-1"
}
}
```
