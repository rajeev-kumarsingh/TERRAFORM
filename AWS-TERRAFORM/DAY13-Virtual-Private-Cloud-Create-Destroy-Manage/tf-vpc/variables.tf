# Define all variables here 
# Declaring an Input Variable

variable "aws_region" {
  description = "N. Verginia Region"
  type = string
  default = "us-east-1"
  
}


# VPC ID
variable "vpc_id" {
  description = "myDemoVpc id"
  type = string
  default = "vpc-0ac7845439ce57321"
}

# ROUTE TABLE ID
variable "route-route_table_id" {
  description = "myDemoVpc Route table id"
  type = string
  default = "rtb-069aeb561f17d1f8a" # Replace with your own route table id
}

# Internet Gateway Id 
variable "aws_internet_gateway" {
  description = "myDemoVpc Internet Gateway ID"
  type = string
  default = "MyDemoVpc-IGW"
  
}


