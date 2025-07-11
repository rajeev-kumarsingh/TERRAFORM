# Day-05: Tasks

1. Input Variables

```tf
variable "image_id" {
  type = string
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a"]
}

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 8300
      external = 8300
      protocol = "tcp"
    }
  ]
}

```

- The label after `variable` keyword is a name for the variable, which must be unique among all variable in the same module, This name is used to assign a value to the variable from outside and to reference the variable's value from within the module.
- The name of a variable can be any valid identifier except the following: `source`, `version`, `providers`, `count`, `for_each`, `lifecycle`, `depends_on`, `locals`.

---

## Input Variable Documentation

- Because the input variables of a module are part of its user interface, you can briefly describe the purpose of each variable using the optional `description` argument:

````

```tf
variable "image_id"{
  type = string
  description = "The id of the machine image (AMI) to use for the server"
}
````

- The description should concisely explain the purpose of the variable and what kind of value is expected. This description string might be included in documentation about the module, and so it should be written from the perspective of the user of the module rather than its maintainer. For commentary for module maintainers, use comments.

## Custom Validation Rules

You can specify custom validation rules for a particular variable by adding a validation block within the corresponding variable block. The example below checks whether the AMI ID has the correct syntax.

```tf
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}


```

## Exclude values from state

> `Note`: Ephemeral variables are available in Terraform v1.10 and later.

- Setting a variable as ephemeral makes it available during runtime, but Terraform omits ephemeral values from state and plan files. Marking an input variable as ephemeral is useful for data that only needs to exist temporarily, such as a short-lived token or session identifier.
- Mark an input variable as ephemeral by setting the ephemeral argument to true:

```tf
variable "session_token" {
  type      = string
  ephemeral = true
}

```

- Ephemeral variables are available during the current Terraform operation, and Terraform does not store them in state or plan files. So, unlike sensitive inputs, Terraform ensures ephemeral values are not available beyond the lifetime of the current Terraform run.
