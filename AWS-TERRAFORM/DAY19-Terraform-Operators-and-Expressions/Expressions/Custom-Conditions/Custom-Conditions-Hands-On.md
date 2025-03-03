# Custom Conditions in Terraform

## Introduction

Terraform allows you to define custom conditions using the `precondition` and `postcondition` blocks inside a resource. These conditions help validate input values and ensure resources are created only if certain criteria are met. This feature, introduced in Terraform 1.2, improves the reliability and correctness of your infrastructure.

## Using `precondition` and `postcondition`

Terraform provides two types of conditions:

- **`precondition`**: Ensures a condition is met before a resource is created or modified.
- **`postcondition`**: Ensures a condition holds true after the resource has been created or updated.

If a condition fails, Terraform will halt execution and return an error message.

## Example: Enforcing Custom Conditions

### Scenario

We are launching an AWS EC2 instance, but we want to ensure:

- The instance type must be one of `t2.micro` or `t3.micro`.
- After creation, the instance must be in the `running` state.

### Terraform Configuration with Custom Conditions

```hcl
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
```

> **RUN** `terraform plan` and enter t2.medium to check `precondition` is working or not
> `Output:`

```sh
terraform plan
var.instance_type
  Type of the EC2 instance

  Enter a value: t2.medium

data.aws_ami.ubuntu: Reading...
data.aws_ami.ubuntu: Read complete after 3s [id=ami-07f9449c0b700566e]

Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Resource precondition failed
│
│   on custom-conditions.tf line 8, in resource "aws_instance" "custom-conditions-example-server":
│    8:       condition = contains(["t2.micro", "t3.micro"], var.instance_type)
│     ├────────────────
│     │ var.instance_type is "t2.medium"
│
│ The instance type must be either t2.micro or t3.micro
╵
```

> **RUN** `Terraform plan -auto-approve` and enter either t2.micro or t3.micro to check `postcondition` is working or not
> `Output:`

```sh
terraform apply -auto-approve
var.instance_type
  Type of the EC2 instance

  Enter a value: t2.micro

data.aws_ami.ubuntu: Reading...
data.aws_ami.ubuntu: Read complete after 4s [id=ami-07f9449c0b700566e]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.custom-conditions-example-server will be created
  + resource "aws_instance" "custom-conditions-example-server" {
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
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags_all                             = (known after apply)
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
aws_instance.custom-conditions-example-server: Creating...
aws_instance.custom-conditions-example-server: Still creating... [10s elapsed]
aws_instance.custom-conditions-example-server: Creation complete after 19s [id=i-0e99cfc7f0fd7ec7f]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

> **RUN** `terraform destroy -auto-approve`

```sh
terraform destroy -auto-approve
var.instance_type
  Type of the EC2 instance

  Enter a value: t2.micro

data.aws_ami.ubuntu: Reading...
data.aws_ami.ubuntu: Read complete after 3s [id=ami-07f9449c0b700566e]
aws_instance.custom-conditions-example-server: Refreshing state... [id=i-0e99cfc7f0fd7ec7f]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.custom-conditions-example-server will be destroyed
  - resource "aws_instance" "custom-conditions-example-server" {
      - ami                                  = "ami-07f9449c0b700566e" -> null
      - arn                                  = "arn:aws:ec2:us-east-1:442042538773:instance/i-0e99cfc7f0fd7ec7f" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-1a" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0e99cfc7f0fd7ec7f" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-011d22e71a2b0d33f" -> null
      - private_dns                          = "ip-172-31-95-1.ec2.internal" -> null
      - private_ip                           = "172.31.95.1" -> null
      - public_dns                           = "ec2-3-82-196-56.compute-1.amazonaws.com" -> null
      - public_ip                            = "3.82.196.56" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-06f72976114aaaa03" -> null
      - tags                                 = {} -> null
      - tags_all                             = {} -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-02544de7340591481",
        ] -> null
        # (8 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/sda1" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-07e12989557ec07e0" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
            # (1 unchanged attribute hidden)
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.
aws_instance.custom-conditions-example-server: Destroying... [id=i-0e99cfc7f0fd7ec7f]
aws_instance.custom-conditions-example-server: Still destroying... [id=i-0e99cfc7f0fd7ec7f, 10s elapsed]
aws_instance.custom-conditions-example-server: Still destroying... [id=i-0e99cfc7f0fd7ec7f, 20s elapsed]
aws_instance.custom-conditions-example-server: Still destroying... [id=i-0e99cfc7f0fd7ec7f, 30s elapsed]
aws_instance.custom-conditions-example-server: Still destroying... [id=i-0e99cfc7f0fd7ec7f, 40s elapsed]
aws_instance.custom-conditions-example-server: Still destroying... [id=i-0e99cfc7f0fd7ec7f, 50s elapsed]
aws_instance.custom-conditions-example-server: Destruction complete after 54s

Destroy complete! Resources: 1 destroyed.
```

## Explanation

1. **Precondition**:

   - `contains(["t2.micro", "t3.micro"], var.instance_type)`: Ensures that the provided instance type is either `t2.micro` or `t3.micro`.
   - If this condition fails, Terraform will display the `error_message` and stop execution.

2. **Postcondition**:
   - `self.instance_state == "running"`: Ensures that after the instance is created, it reaches the `running` state.
   - If this condition fails, Terraform will return an error, ensuring the instance is in the expected state.

## Benefits of Using Custom Conditions

- **Preconditions prevent misconfigurations** before Terraform applies changes.
- **Postconditions validate expected outcomes**, ensuring resources are in the desired state.
- **Improved error handling and debugging** by catching issues early.

## Conclusion

Custom conditions in Terraform provide an extra layer of validation, making infrastructure deployments more robust. By using `precondition` and `postcondition`, you can enforce business rules, avoid common misconfigurations, and ensure that resources meet your operational requirements.
