# Dynamic Security Group Rules in AWS
variable "ingress_rules" {
  type = list(object({
    port =  number
    protocol = string
    cidr_blocks = list(string)
  }))

  default = [ 
    {port = 22, protocol = "tcp", cidr_blocks = [ "0.0.0.0/0" ]},
    {port = 80, protocol = "tcp", cidr_blocks = [ "0.0.0.0/0" ]},
    {port = 443, protocol = "tcp", cidr_blocks = [ "0.0.0.0/0" ]}
  ]
}

resource "aws_security_group" "ssh_http_https" {
  name = "dynamic_sg"
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
    
  }
  
}

output "security_group_ids" {
  
  value = aws_security_group.ssh_http_https.id
  
}

#######################################################################
# Dynamic EBS Volumes for an EC2 Instance
 variable "ebs_volumes1" {
  type = list(object({
    device_name = string
    volume_size = number 
  }))
  default = [ 
    { device_name = "/dev/sdf", volume_size = 10 },
    { device_name = "/dev/sdg", volume_size = 20 }
   ] 
 }

#  resource "aws_ebs_volume" "dynamic_volumes" {
#   count = length(var.ebs_volumes1)

#   availability_zone = "us-east-1"
#   size             = var.ebs_volumes1[count.index].volume_size

#   tags = {
#     Name = "DynamicVolume-${count.index}"
#   }
# }

variable "availability_zone" {
  description = "Availability Zone "
  default = "us-east-1a"
  
}
resource "aws_ebs_volume" "dynamic_volumes" {
  count             = length(var.ebs_volumes1)
  availability_zone = var.availability_zone  # Ensure this contains a valid AZ (e.g., "us-east-1a")
  size             = var.ebs_volumes1[count.index].volume_size

  tags = {
    Name = "DynamicVolume-${count.index}"
  }
}



 ################################################################

# Dynamic Tags in AWS Resources
variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Project     = "Terraform-Demo"
  }
}

# resource "aws_instance" "example" {
#   ami           = "ami-12345678"
#   instance_type = "t2.micro"

#   tags = {
#     for key, value in var.tags : key => value
#   }
# }


#######################################################################
# Dynamic Provisioner Block
variable "commands" {
  type = list(string)
  default = ["echo 'Hello, World!'", "uptime"]
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  #key_name      = "my-key"  # Ensure you have a key pair created in AWS

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"  # Change for Ubuntu (`ubuntu`) or other OS users
      #private_key = file("~/.ssh/my-key.pem")
      host        = self.public_ip
    }

    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx"
    ]
  }
}
