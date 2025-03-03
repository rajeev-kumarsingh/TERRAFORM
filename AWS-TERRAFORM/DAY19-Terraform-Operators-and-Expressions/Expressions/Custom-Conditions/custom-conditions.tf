
resource "aws_instance" "custom-conditions-example-server" {
  ami = data.aws_ami.ubuntu.id 
  instance_type = var.instance_type

  lifecycle {
    precondition {
      condition = contains(["t2.micro", "t3.micro"], var.instance_type)
      error_message = "The instance type must be either t2.micro or t3.micro"
    }
    postcondition {
      condition = self.instance_state == "running"
      error_message = "The instance should be in 'running' state after creation."
    }
  }
  
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type = string
  
}