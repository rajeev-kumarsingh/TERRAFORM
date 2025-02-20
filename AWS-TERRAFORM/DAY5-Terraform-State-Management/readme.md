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

## **9. Terraform State Management**

Terraform state files track the infrastructure managed by Terraform. Proper state management ensures consistency and collaboration.

### **Check the State File**

```sh
terraform state list
```

This command lists all resources tracked in the Terraform state file.

### **View Details of a Specific Resource**

```sh
terraform state show aws_instance.my_ec2
```

This command shows details of a specific resource.

### **Manually Inspect the State File**

```sh
cat terraform.tfstate
```

This file contains JSON data representing Terraform-managed infrastructure.

### **Move a Resource in the State File**

```sh
terraform state mv aws_instance.my_ec2 aws_instance.new_name
```

This renames a resource in the state without re-creating it.

### **Remove a Resource from the State File**

```sh
terraform state rm aws_instance.my_ec2
```

This removes the resource from Terraform’s tracking but does not delete it from the cloud.

### **Remote State Management Using S3 Backend**

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

This initializes the remote state storage.

---

## **10. Using Terraform Variables**

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

## **11. Terraform Best Practices**

✅ **Use Version Control (Git)**: Store your Terraform files in Git.  
✅ **Use Remote State**: Avoid local state storage for team collaboration.  
✅ **Keep Terraform DRY**: Use modules to avoid duplication.  
✅ **Use Workspaces**: Terraform workspaces help manage multiple environments.  
✅ **Use CI/CD for Terraform**: Automate infrastructure deployment.

---

## **Conclusion**

This guide covered Terraform from **basic setup to advanced concepts** like **variables, modules, state management, remote state, and best practices**.

#

# State Management

- The state file `terraform.tfstate` maintains a detail record of the current `state` of managed resources.
- This `state` file can be stored localy or remotely, with remote storage options enabling collaboration by sharing the state across `team` and `environments`.
