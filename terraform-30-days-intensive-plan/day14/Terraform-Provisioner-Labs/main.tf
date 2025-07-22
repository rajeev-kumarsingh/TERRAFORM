provider "aws" {
  # Configurations
  region = "us-east-1"
}
/*
Data block to retrive vpc id and other rewuired details
*/
# variable "vpc_id" {}
data "aws_vpc" "vpc_id" {
  default = true
}
# Get Latest Ubuntu AMI ID
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

  owners = ["099720109477"] # Canonical (official Ubuntu publisher)
}

# Subnet Data Blog(Using Default Subment)
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

/* Purpose: Generates an RSA private/public key pair.
 Output attributes:
private_key_pem: PEM-encoded private key.
public_key_openssh: Public key in OpenSSH format (needed for AWS).
 Note: This runs each time Terraform is applied unless protected.
*/
resource "tls_private_key" "generated" {
  algorithm = "RSA"

  # Avoid Regeneration on Every Apply
  # lifecycle {
  #   prevent_destroy = true
  # }

}

# Save Private Key Locally
resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyTfProvisionerKey.pem"

  # Secure the Private Key
  file_permission = "0400" # Newer Terraform versions support this

}

/* Create AWS EC2 Key Pair
Purpose: Uploads the generated public key to AWS as an EC2 key pair.

*/
resource "aws_key_pair" "imported" {
  key_name   = "MyTfProvisionerKey"
  public_key = tls_private_key.generated.public_key_openssh

}

# Key:pair part end here 
/*
Security Groups
1. Security Group that allows SSH access
2. Security Group that allows web traffic over the standard HTTP and HTTPS ports.
3. ICMP security group for Ping Access
*/

# Security Group to allow SSH
resource "aws_security_group" "ingress-ssh" {
  name        = "Allow_SSH"
  vpc_id      = data.aws_vpc.vpc_id.id
  description = "Allow SSH"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  // Terraform removes the default rule
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

}


# Security Group that allows web traffic over the standard HTTP and HTTPS ports.
resource "aws_security_group" "vpc-web" {
  name        = "vpc-web-${terraform.workspace}"
  vpc_id      = data.aws_vpc.vpc_id.id
  description = "Web Traffic"
  ingress {
    description = "Allow Port 80"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "Allow Port 443"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  egress {
    description = "Allow all IP and Ports outbond"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }


}
# aws_security_group.vpc-ping – ICMP for Ping Access
# Allow incoming ICMP traffic (used by ping) and all outbound traffic.
resource "aws_security_group" "vpc-ping" {
  description = "ICMP for ping access"
  vpc_id      = data.aws_vpc.vpc_id.id
  name        = "vpc-ping"
  ingress {
    description = "Allow ICMP Traffic"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outbond"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Task 3: Create a connection block using your keypair module outputs.

resource "aws_instance" "ubuntu-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.public.id
  # ⚠️ Note: Using security_groups only works with EC2-Classic or default VPC. For custom VPC, use vpc_security_group_ids.
  security_groups = [aws_security_group.ingress-ssh.id, aws_security_group.vpc-ping.id, aws_security_group.vpc-web.id]
  key_name        = aws_key_pair.imported.key_name

  # Connection Block
  # This is used by provisioners (like remote-exec or file) to SSH into the instance.
  connection {
    user        = "ubuntu"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }

  # ⬇️ Add local-exec here
  # The local-exec provisioner runs commands on your local machine (not inside the EC2) after a resource is created.
  provisioner "local-exec" {
    command = "echo my-public-ip-is:-${self.public_ip} >> ec2_public_ip.txt"
  }
  # Add remote-exec here 
  #   provisioner "remote-exec" {
  #   inline = [
  #     "sudo rm -rf /tmp/demo-terraform-101",
  #     "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp/demo-terraform-101",
  #     "cd /tmp/demo-terraform-101/assets && sudo ./setup-web.sh"
  #   ]
  # }
  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /tmp/demo-terraform-101",
      "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp/demo-terraform-101",
      "sudo cp /tmp/demo-terraform-101/assets/webapp /usr/local/bin/webapp",
      "sudo cp /tmp/demo-terraform-101/assets/webapp.service /etc/systemd/system/webapp.service",
      "sudo chmod +x /usr/local/bin/webapp",
      "sudo systemctl daemon-reexec",
      "sudo systemctl start webapp",
      "sudo systemctl enable webapp"
    ]
  }




  tags = {
    Name = "Ubuntu Ec2 Server"
  }
  # This prevents Terraform from recreating the instance if the security_groups are changed outside Terraform.
  lifecycle {
    ignore_changes = [security_groups]
  }
}
