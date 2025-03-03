# Sets
# Terraform does not support directly accessing elements of a set by index because sets are unordered collections. To access elements in a set by index, first convert the set to a list.

# terraform {}


# 1. Define a set
variable "example_set" {
  type = set(string)
  default = [ "Rajeev", "Singh" ]
  
}

# 2. Use to tolist function to convert the set to a list 
locals {
  example_list = tolist(var.example_set)
}
# 3. You can then reference an element in the list:
output "first_elemetnt" {
  value = local.example_list[0]
  
}
output "second_element" {
  value = local.example_list[1]
  
}

# Heredoc Strings
# value<<EOT
# hello
# world
# EOT

# Indented Heredocs
locals {
  value = <<EOT
  Hello
  world
  EOT
}


# To improve on this, Terraform also accepts an indented heredoc string variant that is introduced by the <<- sequence:
locals {
  valuename = <<-EOT
  hello
  Rajeev
  EOT
}

output "heredocs_string" {
  value = local.valuename
  
}
output "heredocs_string1" {
  value = local.value
}

# String Templates
#####################################################
# 1. Basic Interpolation
variable "name" {
  default = "  "
  
}

output "greeting" {
  value = "Hello, ${var.name}"
  
}
#####################################################
#####################################################
# 2. Multi-line Strings (Heredoc Syntax)
output "multiline_example" {
  value = <<-EOT
  Hello, ${var.name}!
  You are the best.
  This is multiline example
  EOT
  
}

output "multiline_example1" {
  value = <<EOT
  Hello, ${var.name}!
  You are the best.
  This is multiline example
  EOT
  
}

############################################################
############################################################
# The %{if <BOOL>}/%{else}/%{endif} directive chooses between two templates based on the value of a bool expression:
output "ifelse" {
  value = "Hello, %{ if var.name != "" }${var.name}%{else }unamed%{ endif }!"
  
}
###########################################################
###########################################################
variable "list" {
  default = ["one", "two", "three", "four", "five"]
  
}

# he %{for <NAME> in <COLLECTION>} / %{endfor} directive iterates over the elements of a given collection or structural value and evaluates a given template once for each element, concatenating the results together:
output "forloop" {
  value = <<-EOF
  %{for i in var.list}
  items ${var.list[0]}
  items ${i}
  %{endfor}

  EOF
  
}
# The name given immediately after the for keyword is used as a temporary variable name which can then be referenced from the nested template.

##################################################################


##################################################################
# Function Calls
variable "function_example" {
  description = "Use this variable in function call"
  default = [1, 2, 3, 4, 5]
}

output "function_call_example" {
  value = <<-EOF
  The minimum value in this list is : ${min(var.function_example...)}

  List of Values:
  %{for i in var.function_example}
  values: ${i}
  %{endfor}
  
  Another way to find min of list is:
  Minimum value of the given list is: ${min(tolist(var.function_example)[0],
                                            tolist(var.function_example)[1],
                                            tolist(var.function_example)[2],
                                            tolist(var.function_example)[3],
                                            tolist(var.function_example)[4])}

  
  EOF
# Explanation
# Using tolist(var.function_example)

# Ensures the list is treated as an indexed array.
# Access elements explicitly using [index].
  
  
}

# Explanation
# min(var.function_example...):

# The splat operator (...) expands the list values into arguments.
# min(1, 2, 3, 4, 5) → returns 1.



##################################################################

##################################################################
# # Values Not Yet Known
# resource "aws_instance" "myapp_server" {
#   ami = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   security_groups = [ data.aws_security_groups.find-sg-by-tag.id ]
#   tags = {
#     Name = "myapp_server"
#   }
  
# }
##################################################################



##################################################################
# Conditional Expressions
# If condition is true then the result is true_val. If condition is false then the result is false_val.

# A common use of conditional expressions is to define defaults to replace invalid values:

output "conditional_expression_examples" {
  description = "A common use of conditional expressions is to define defaults to replace invalid values:"
  value = trimspace(var.name) == "" ? "default-a":var.name
  # If var.a is an empty string then the result is "default-a", but otherwise it is the actual value of var.a.

  
}

##################################################################


##################################################################
# for expressions

variable "for_expression_list" {
  description = "List of string"
  type = list(string)
  default = ["one", "two", "three", "four", "five"]
}

# For example, if var.list were a list of strings, then the following expression would produce a tuple of strings with all-uppercase letters:
# with [] brackets
output "for_expressions_example" {
  description = "if var.list were a list of strings, then the following expression would produce a tuple of strings with all-uppercase letters"
  value = [for s in var.for_expression_list : upper(s)]

  
}

# With Curly brackets represent object
variable "for_expression_object" {
  description = "List of objects"
  type = list(object({
    first  = string
    second = string
    third  = string
    fourth = string
    last   = string
  }))
  default = [{
    first = "one"
    second = "two"
    third ="three"
    fourth =  "four"
    last= "five"
    }]
}
# with {} bracket
output "for_expressions_example_curly" {
  value = {for k, v  in var.for_expression_object[0] : k => upper(v)}
  
}


##### Filtering Elements#####
variable "filtering_element" {
  description = "for expression can also include an optional if clause to filter elements from the source collection, producing a value with fewer elements than the source value:"
  type = list(string)
  default = ["First_element"," ", "Two"," ", "Three"," ", "Four"," ", "Last_element"]
}

output "filtering_example_output" {
  description = "value"
  value = [for i in var.filtering_element: upper(i) if i != ""]
  
}


# type =  map(object({is_admin =bool}))
variable "users" {
  type = map(object({
    is_admin = bool
  }))
}
  locals {
    admin_users = {
      for name, user in var.users : name => user
      if user.is_admin
    }
    regular_user = {
      for name, user in var.users : name => user
      if !user.is_admin
    }

  }
  
  output "admin_users" {
    description = "if the input var.users is a map of objects where the objects each have an attribute is_admin then you may wish to produce separate maps with admin vs non-admin objects"
    value = local.admin_users
    
  }
  output "regular_user" {
    description = "Get regular users"
    value = local.regular_user
    
  }
  


##################################################################

###################################################################
# splat Expression
# Examples of Splat Expressions
# (A) Full Splat ([*]) in Resource Attributes
resource "aws_instance" "webapp" {
  count = 3 # Creates 3 instances 
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  
}
output "public_ips" {
  description = "List all the public IPs if instance which name starts from web[*]"
  value = aws_instance.webapp[*].public_ip

  
}

# Instance IDS
output "instance_ids" {
  description = "List all 3 instance ids"
  value = aws_instance.webapp.*.id 

  
}

# Using Splat Expressions in Maps

variable "servers" {
  default = {
    Web = "192.168.1.10"
    Db = "192.168.1.11"
    Cache = "192.168.1.12" 
  }
  
}
output "server_ips" {
  value = values(var.servers)
  
}

####################################################################

###################################################################
# Dynamic Blocks

####################################################################

###################################################################
# Custom Conditions

####################################################################

###################################################################
# Type Constraint

####################################################################

###################################################################
# Version Constraint

####################################################################