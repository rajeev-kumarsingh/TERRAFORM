# Terraform Registry Practice Lab (.md)

## Objective

Deploy **AWS VPC, EC2, S3, and ALB** using Terraform Registry modules with reusable, modular infrastructure as code.

## Modules Used

✅ `terraform-aws-modules/vpc/aws` ✅ `terraform-aws-modules/s3-bucket/aws` ✅ `terraform-aws-modules/ec2-instance/aws` ✅ `terraform-aws-modules/alb/aws`

## Structure

- `main.tf`: Module calls and providers
- `variables.tf`: Input variables
- `outputs.tf`: Outputs for inspection

## Steps

1️⃣ **Initialize Terraform Project**

```bash
mkdir terraform-practice-lab
cd terraform-practice-lab
touch main.tf variables.tf outputs.tf
```

2️⃣ **Add AWS Provider** in `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}
```

3️⃣ **Use VPC Module**

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = "lab-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}
```

4️⃣ **Use S3 Module**

```hcl
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"

  bucket = "my-lab-bucket-${random_id.bucket_suffix.hex}"
  acl    = "private"
}
```

5️⃣ **Use EC2 Module**

```hcl
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = "lab-ec2"
  ami  = "ami-0c55b159cbfafe1f0" # update to your region
  instance_type = "t3.micro"

  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.vpc.default_security_group_id]
}
```

6️⃣ **Use ALB Module**

```hcl
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.3.0"

  name = "lab-alb"

  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets

  security_groups = [module.vpc.default_security_group_id]
}
```

7️⃣ **Outputs (**``**)**

```hcl
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "s3_bucket_name" {
  value = module.s3_bucket.s3_bucket_id
}

output "ec2_instance_id" {
  value = module.ec2_instance.id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}
```

8️⃣ **Initialize, Plan, and Apply**

```bash
terraform init
terraform plan
terraform apply
```

✅ This will deploy a fully functioning VPC, EC2, S3, and ALB stack using Terraform Registry modules for your practical learning.

