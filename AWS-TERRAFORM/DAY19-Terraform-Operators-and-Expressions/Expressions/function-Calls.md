---
page_title: Function Calls - Configuration Language
description: >-
  Functions transform and combine values. Learn about Terraform's built-in
  functions.
---

# Function Calls

> **Hands-on:** Try the [Perform Dynamic Operations with Functions](/terraform/tutorials/configuration-language/functions?utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS) tutorial.

The Terraform language has a number of
[built-in functions](/terraform/language/functions) that can be used
in expressions to transform and combine values. These
are similar to the operators but all follow a common syntax:

```hcl
<FUNCTION NAME>(<ARGUMENT 1>, <ARGUMENT 2>)
```

The function name specifies which function to call. Each defined function
expects a specific number of arguments with specific value types, and returns a
specific value type as a result.

Some functions take an arbitrary number of arguments. For example, the `min`
function takes any amount of number arguments and returns the one that is
numerically smallest:

```hcl
min(55, 3453, 2)
```

A function call expression evaluates to the function's return value.

## Available Functions

For a full list of available functions, see
[the function reference](/terraform/language/functions).

## Expanding Function Arguments

If the arguments to pass to a function are available in a list or tuple value,
that value can be _expanded_ into separate arguments. Provide the list value as
an argument and follow it with the `...` symbol:

```hcl
min([55, 2453, 2]...)
```

The expansion symbol is three periods (`...`), not a Unicode ellipsis character
(`…`). Expansion is a special syntax that is only available in function calls.

## Using Sensitive Data as Function Arguments

When using sensitive data, such as [an input variable](/terraform/language/values/variables#suppressing-values-in-cli-output)
or [an output defined](/terraform/language/values/outputs#sensitive-suppressing-values-in-cli-output) as sensitive
as function arguments, the result of the function call will be marked as sensitive.

This is a conservative behavior that is true irrespective of the function being
called. For example, passing an object containing a sensitive input variable to
the `keys()` function will result in a list that is sensitive:

```shell
> local.baz
{
  "a" = (sensitive value)
  "b" = "dog"
}
> keys(local.baz)
(sensitive value)
```

## When Terraform Calls Functions

Most of Terraform's built-in functions are, in programming language terms,
[pure functions](https://en.wikipedia.org/wiki/Pure_function). This means that
their result is based only on their arguments and so it doesn't make any
practical difference when Terraform would call them.

However, a small subset of functions interact with outside state and so for
those it can be helpful to know when Terraform will call them in relation to
other events that occur in a Terraform run.

The small set of special functions includes
[`file`](/terraform/language/functions/file),
[`templatefile`](/terraform/language/functions/templatefile),
[`timestamp`](/terraform/language/functions/timestamp),
and [`uuid`](/terraform/language/functions/uuid).
If you are not working with these functions then you don't need
to read this section, although the information here may still be interesting
background information.

The `file` and `templatefile` functions are intended for reading files that
are included as a static part of the configuration and so Terraform will
execute these functions as part of initial configuration validation, before
taking any other actions with the configuration. That means you cannot use
either function to read files that your configuration might generate
dynamically on disk as part of the plan or apply steps.

The `timestamp` function returns a representation of the current system time
at the point when Terraform calls it, and the `uuid` function returns a random
result which differs on each call. Without any special behavior, these would
both cause the final configuration during the apply step not to match the
actions shown in the plan, which violates the Terraform execution model.

For that reason, Terraform arranges for both of those functions to produce
[unknown value](/terraform/language/expressions/references#values-not-yet-known) results during the
plan step, with the real result being decided only during the apply step.
For `timestamp` in particular, this means that the recorded time will be
the instant when Terraform began applying the change, rather than when
Terraform _planned_ the change.

For more details on the behavior of these functions, refer to their own
documentation pages.

`Example`
`terraform plan`

```sh
terraform plan
data.aws_availability_zones.available: Reading...
data.aws_security_group.find-by-name: Reading...
data.aws_ami.ubuntu: Reading...
data.aws_security_groups.find-sg-by-tag: Reading...
data.aws_caller_identity.current: Reading...
data.aws_caller_identity.current: Read complete after 0s [id=442042538773]
data.aws_availability_zones.available: Read complete after 2s [id=us-east-1]
data.aws_security_group.find-by-name: Read complete after 2s [id=sg-0f147807f26d8036b]
data.aws_security_groups.find-sg-by-tag: Read complete after 2s [id=us-east-1]
data.aws_ami.ubuntu: Read complete after 3s [id=ami-07f9449c0b700566e]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.myapp_server will be created
  + resource "aws_instance" "myapp_server" {
      + ami                                  = "ami-07f9449c0b700566e"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = [
          + "us-east-1",
        ]
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "myapp_server"
        }
      + tags_all                             = {
          + "Name" = "myapp_server"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + account_id             = "442042538773"
  + aws_ami                = "ami-07f9449c0b700566e"
  + aws_availability_zones = [
      + "us-east-1a",
      + "us-east-1b",
      + "us-east-1c",
      + "us-east-1d",
      + "us-east-1e",
      + "us-east-1f",
    ]
  + caller_arn             = "arn:aws:iam::442042538773:user/rajeev442042538773"
  + caller_user_id         = "AIDAWN26J3MKZ66QCAXVX"
  + first_az               = "us-east-1a"
  + first_elemetnt         = "Rajeev"
  + forloop                = <<-EOT
        items one
        items one

        items one
        items two

        items one
        items three

        items one
        items four

        items one
        items five
    EOT
  + function_call_example  = <<-EOT
        The minimum value in this list is : 1

        List of Values:

        values: 1

        values: 2

        values: 3

        values: 4

        values: 5


        Another way to find min of list is:
        Minimum value of the given list is: 1
    EOT
  + greeting               = "Hello,  Rajeev "
  + heredocs_string        = <<-EOT
        hello
        Rajeev
    EOT
  + heredocs_string1       = <<-EOT
        Hello
          world
    EOT
  + ifelse                 = "Hello,  Rajeev !"
  + multiline_example      = <<-EOT
        Hello,  Rajeev !
        You are the best.
        This is multiline example
    EOT
  + multiline_example1     = <<-EOT
        Hello,  Rajeev !
          You are the best.
          This is multiline example
    EOT
  + second_az              = "us-east-1b"
  + second_element         = "Singh"
  + security_group_by_name = "sg-0f147807f26d8036b"
  + security_group_by_tag  = "us-east-1"

─────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly
these actions if you run "terraform apply" now.
```
