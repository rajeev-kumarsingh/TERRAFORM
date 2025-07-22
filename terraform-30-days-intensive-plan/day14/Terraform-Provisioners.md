
# Terraform Provisioners

Terraform **provisioners** are used to execute scripts or commands on a local or remote machine as part of resource creation or destruction. They can be helpful for bootstrapping, configuration management, or performing specific tasks when infrastructure is created or destroyed.

> ⚠️ Note: Provisioners should be avoided if possible and used only when there is no other way, as they break the declarative model of Terraform.

---

## Types of Provisioners

### 1. `local-exec`
Executes commands on the machine running Terraform (your local machine or CI/CD runner).

#### Example:
```hcl
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello from local-exec"
  }
}
```

### 2. `remote-exec`
Executes commands on a remote resource (e.g., EC2 instance) via SSH or WinRM.

#### Example with SSH (Linux):
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx"
    ]

    connection {
      type        = "ssh",
      user        = "ec2-user",
      private_key = file("~/.ssh/my-key.pem"),
      host        = self.public_ip
    }
  }
}
```

---

## File Provisioner

Used to copy files or directories to the remote machine.

#### Example:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"

    connection {
      type        = "ssh",
      user        = "ec2-user",
      private_key = file("~/.ssh/my-key.pem"),
      host        = self.public_ip
    }
  }
}
```

---

## Using `null_resource` with Provisioners

`null_resource` can be used when you want to run provisioners independently of a specific resource.

#### Example:
```hcl
resource "null_resource" "script_runner" {
  provisioner "local-exec" {
    command = "echo Provisioning with local script..."
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
```

---

## Best Practices

- Use provisioners as a last resort.
- Prefer cloud-init, Ansible, or native cloud features instead of provisioners.
- Use `triggers` in `null_resource` to control re-execution.
- Avoid depending on provisioner outputs in downstream resources.

---

## When to Use Provisioners

✅ Custom configuration or bootstrap scripts  
✅ Copying files to an instance  
✅ One-time execution during provisioning

❌ Avoid for general-purpose configuration — use configuration management tools instead.

---

## References

- [Terraform Docs: Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners)
