variable "aws_image" {
  description = "Image ID"
  type = string

  
}

variable "availability_zones" {
  description = "azs"
  type = list(string)
  default = [ "us-east-1" ]
    
}

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string 
  }))
  default = [ {
    internal = 8300
    external = 8300
    protocol = "tcp"
  } ]
}


# Custom validation rules
variable "image_id" {
  type = string
  description = "The id of the machine image (AMI) to use for the server"
  validation {
    condition = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image id value must be a valid AMI id, starting with \"ami-\"."
  }
}