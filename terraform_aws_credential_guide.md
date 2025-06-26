# Connecting Terraform to AWS using Credentials

Terraform needs AWS credentials to authenticate and authorize API requests. Here are several common and secure methods to connect Terraform to AWS.

---

## ✅ 1. Environment Variables (Recommended for Local Dev/Test)

Set the following environment variables in your terminal:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"
```

---

## ✅ 2. AWS Credentials File

Terraform automatically reads from `~/.aws/credentials`.

### Example: ~/.aws/credentials

```ini
[default]
aws_access_key_id = your-access-key-id
aws_secret_access_key = your-secret-access-key
```

### Example: ~/.aws/config

```ini
[default]
region = us-east-1
```

Use a profile with:

```bash
export AWS_PROFILE=your_profile_name
```

---

## ✅ 3. Hardcoded in Terraform Provider Block (Not Recommended)

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "your-access-key-id"
  secret_key = "your-secret-access-key"
}
```

⚠️ **Warning:** Avoid hardcoding credentials in code repositories.

---

## ✅ 4. IAM Role for EC2/EKS/ECS

Terraform will automatically use IAM Role attached to EC2, ECS, or EKS instances using the AWS metadata service. No manual configuration is needed.

---

## ✅ 5. Assume Role with AWS Profile

In your `~/.aws/config`:

```ini
[profile myadmin]
role_arn = arn:aws:iam::ACCOUNT_ID:role/YourRole
source_profile = default
region = us-east-1
```

Then run:

```bash
export AWS_PROFILE=myadmin
```

---

## ✅ 6. AWS SSO (Single Sign-On)

1. Configure profile:

```bash
aws configure sso
```

2. Use with Terraform:

```bash
export AWS_PROFILE=your-sso-profile
```

---

## ✅ 7. Provider Block with Profile and Credentials File

```hcl
provider "aws" {
  profile                 = "your_profile"
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-east-1"
}
```

---

## ✅ 8. Using `aws-vault` or `saml2aws`

### Using `aws-vault`:

```bash
aws-vault exec your-profile -- terraform apply
```

This securely stores and injects credentials into your shell session.

---

**Choose the method that fits your use case:**

- ✅ Local dev → Env vars or AWS credentials file
- ✅ CI/CD or EC2/EKS → IAM Roles
- ✅ Organizations → SSO or AssumeRole
- ✅ Secure automation → `aws-vault` or `saml2aws`
