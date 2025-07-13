# Variable Block named public_subnet
variable "public_subnet" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }

}
# Variable Block named variable_sub_cidr

variable "variable_sub_cidr" {
  description = "CIDR block for the variable subnet"
  type        = string
  default     = "10.0.0.0/24"

}

# Variable Block named variable_sub_az

variable "variable_sub_az" {
  description = "Availability zone used varibale subnet"
  type        = string
  default     = "us-east-1a"

}

# Variable Block named variable_sub_auto_ip

variable "variable_sub_auto_ip" {
  description = "Set automatic IP assignment for variable subnet"
  type        = bool
  default     = true


}

# Variable Block named environment

variable "environment" {
  description = "Environment for deployment"
  type        = string
  default     = "dev"

}

# Variable block for instance type
variable "instance_type" {
  description = "Instance type used for ec2 instances"
  type        = string
  default     = "t2.micro"

}