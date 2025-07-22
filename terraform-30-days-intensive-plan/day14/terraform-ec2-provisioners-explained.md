# Terraform EC2 with Provisioners – Full Explanation

This configuration launches an EC2 Ubuntu instance in AWS and sets up everything from VPC selection, security groups, SSH key pair, and provisions the instance with `local-exec` and `remote-exec`.

---

## ✅ Key Sections Explained

### 1. **Provider**
```hcl
provider "aws" {
  region = "us-east-1"
}
```
Sets AWS provider and region for your resources.

---

### 2. **Get Default VPC and Subnet**
```hcl
data "aws_vpc" "vpc_id" {
  default = true
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_id.id]
  }
}
```
Uses data sources to find existing default VPC and a public subnet by tag.

---

### 3. **Ubuntu AMI**
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
```
Fetches the latest Ubuntu 22.04 AMI from Canonical.

---

### 4. **TLS Key Pair**
```hcl
resource "tls_private_key" "generated" {
  algorithm = "RSA"
  lifecycle {
    prevent_destroy = true
  }
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyTfProvisionerKey.pem"
  file_permission = "0400"
}
```
Generates RSA key pair and saves the private key locally with secure permissions.

---

### 5. **AWS EC2 Key Pair**
```hcl
resource "aws_key_pair" "imported" {
  key_name   = "MyTfProvisionerKey"
  public_key = tls_private_key.generated.public_key_openssh
}
```
Imports the public key to AWS as a Key Pair.

---

### 6. **Security Groups**
Defines SSH, Web (HTTP/HTTPS), and ICMP access using individual `aws_security_group` resources.

---

### 7. **EC2 Instance + Provisioners**
```hcl
resource "aws_instance" "ubuntu-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.public.id
  security_groups = [
    aws_security_group.ingress-ssh.id,
    aws_security_group.vpc-ping.id,
    aws_security_group.vpc-web.id
  ]
  key_name = aws_key_pair.imported.key_name

  connection {
    user        = "ubuntu"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2_public_ip.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /tmp/demo-terraform-101",  # safer than rm -f /tmp
      "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp/demo-terraform-101",
      "sudo sh /tmp/demo-terraform-101/assets/setup-web.sh"
    ]
  }

  tags = {
    Name = "Ubuntu Ec2 Server"
  }

  lifecycle {
    ignore_changes = [security_groups]
  }
}
```

---

### 📌 Provisioners Explained

#### ✅ `local-exec`
- Runs on your **local machine** after the resource is created.
- Saves EC2 instance public IP to a file.

#### ✅ `remote-exec`
- Runs commands **inside the EC2 instance over SSH**.
- Uses the `connection` block to connect using the generated key.
- Example:
    - Clones GitHub repo
    - Executes shell script to configure web server

---

### ⚠️ Fix for `rm -f /tmp` Error

> `rm -f /tmp` may fail because `/tmp` is a critical directory. Replace:
```sh
"sudo rm -f /tmp"
```
✅ With:
```sh
"sudo rm -rf /tmp/demo-terraform-101"
```

---

### ✅ Final Recommendations

- Always use `prevent_destroy` with key-pair to avoid key regeneration.
- Use `file_permission = "0400"` to secure private keys.
- Prefer `vpc_security_group_ids` over `security_groups` in custom VPCs.
- Check EC2 logs with `terraform apply -auto-approve && tail -f /var/log/cloud-init-output.log`.

---

© DevOps Gyan Rajeev