variable "public_subnet" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }

}

variable "variable_sub_cidr" {
  description = "CIDR block for the variable subnet"
  type        = string
  default     = "10.0.0.0/24"

}

variable "variable_sub_az" {
  description = "Availability zone used varibale subnet"
  type        = string
  default     = "us-east-1a"

}

variable "variable_sub_auto_ip" {
  description = "Set automatic IP assignment for variable subnet"
  type        = bool
  default     = true


}