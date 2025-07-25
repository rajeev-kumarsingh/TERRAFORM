---
page_title: Provisioner Connection Settings
description: >-
  The connection block allows you to manage provisioner connection defaults for
  SSH and WinRM.
---

# Provisioner Connection Settings

Most provisioners require access to the remote resource via SSH or WinRM and
expect a nested `connection` block with details about how to connect.

~> **Important:** Use provisioners as a last resort. There are better alternatives for most situations. Refer to
[Declaring Provisioners](/terraform/language/resources/provisioners/syntax) for more details.

## Connection Block

You can create one or more `connection` blocks that describe how to access the remote resource. One use case for providing multiple connections is to have an initial provisioner connect as the `root` user to set up user accounts and then have subsequent provisioners connect as a user with more limited permissions.

Connection blocks don't take a block label and can be nested within either a
`resource` or a `provisioner`.

* A `connection` block nested directly within a `resource` affects all of
  that resource's provisioners.
* A `connection` block nested in a `provisioner` block only affects that
  provisioner and overrides any resource-level connection settings.

Since the SSH connection type is most often used with
newly-created remote resources, validation of SSH host keys is disabled by
default. If this is not acceptable, you can establish a separate mechanism for key distribution and explicitly set the `host_key` argument (details below) to verify against a specific key or signing CA.

-> **Note:** In Terraform 0.11 and earlier, providers could set default values
for some connection settings, so that `connection` blocks could sometimes be
omitted. This feature was removed in 0.12 in order to make Terraform's behavior
more predictable.

### Ephemeral values

-> **Note**: Ephemeral values are available in Terraform v1.10 and later.

The configuration for a `connection` block may use ephemeral values, such as
[`ephemeral` resources](/terraform/language/resources/ephemeral), [`ephemeral`
local values](/terraform/language/values/locals#ephemeral-values), [`ephemeral`
variables](/terraform/language/values/variables#ephemeral), or [`ephemeral`
output
values](/terraform/language/values/outputs#ephemeral-avoid-storing-values-in-state-or-plan-files).

Terraform will not store these values in your plan or state, or output them in
logs.

### Example usage

```hcl
# Copies the file as the root user using SSH
provisioner "file" {
  source      = "conf/myapp.conf"
  destination = "/etc/myapp.conf"

  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = var.host
  }
}

# Copies the file as the Administrator user using WinRM
provisioner "file" {
  source      = "conf/myapp.conf"
  destination = "C:/App/myapp.conf"

  connection {
    type     = "winrm"
    user     = "Administrator"
    password = var.admin_password
    host     = var.host
  }
}
```

### The `self` Object

Expressions in `connection` blocks cannot refer to their parent resource by name. References create dependencies, and referring to a resource by name within its own block would create a dependency cycle. Instead, expressions can use the `self` object, which represents the connection's parent resource and has all of that resource's attributes. For example, use `self.public_ip` to reference an `aws_instance`'s `public_ip` attribute.


### Argument Reference

The `connection` block supports the following arguments. Some arguments are only supported by either the SSH or the WinRM connection type.


| Argument | Connection Type | Description | Default |
|---------------|--------------|-------------|---------|
| `type` | Both | The connection type. Valid values are `"ssh"` and `"winrm"`. Provisioners typically assume that the remote system runs Microsoft Windows when using WinRM. Behaviors based on the SSH `target_platform` will force Windows-specific behavior for WinRM, unless otherwise specified.| `"ssh"` |
| `user` | Both | The user to use for the connection. | `root` for type `"ssh"`<br />`Administrator` for type `"winrm"` |
| `password` | Both | The password to use for the connection. | |
| `host` | Both | **Required** - The address of the resource to connect to. | |
| `port` | Both| The port to connect to. | `22` for type `"ssh"`<br />`5985` for type `"winrm"` |
| `timeout` | Both | The timeout to wait for the connection to become available. Should be provided as a string (e.g., `"30s"` or `"5m"`.) | `"5m"` |
| `script_path` | Both | The path used to copy scripts meant for remote execution. Refer to [How Provisioners Execute Remote Scripts](#how-provisioners-execute-remote-scripts) below for more details. | (details below) |
| `private_key` | SSH | The contents of an SSH key to use for the connection. These can be loaded from a file on disk using [the `file` function](/terraform/language/functions/file). This takes preference over `password` if provided. | |
| `certificate` | SSH | The contents of a signed CA Certificate. The certificate argument must be used in conjunction with a `private_key`. These can be loaded from a file on disk using the [the `file` function](/terraform/language/functions/file). | |
| `agent` | SSH | Set to `false` to disable using `ssh-agent` to authenticate. On Windows the only supported SSH authentication agent is [Pageant](http://the.earth.li/\~sgtatham/putty/0.66/htmldoc/Chapter9.html#pageant). |   |
| `agent_identity` | SSH | The preferred identity from the ssh agent for authentication. | |
| `host_key` | SSH | The public key from the remote host or the signing CA, used to verify the connection. | |
| `target_platform` | SSH | The target platform to connect to. Valid values are `"windows"` and `"unix"`. If the platform is set to `windows`, the default `script_path` is `c:\windows\temp\terraform_%RAND%.cmd`, assuming [the SSH default shell](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration#configuring-the-default-shell-for-openssh-in-windows) is `cmd.exe`. If the SSH default shell is PowerShell, set `script_path` to `"c:/windows/temp/terraform_%RAND%.ps1"` | `"unix"` |
| `https` | WinRM | Set to `true` to connect using HTTPS instead of HTTP. | |
| `insecure` | WinRM | Set to `true` to skip validating the HTTPS certificate chain. | |
| `use_ntlm` | WinRM | Set to `true` to use NTLM authentication rather than default (basic authentication), removing the requirement for basic authentication to be enabled within the target guest. Refer to [Authentication for Remote Connections](https://docs.microsoft.com/en-us/windows/win32/winrm/authentication-for-remote-connections) in the Windows App Development documentation for more details. | |
| `cacert` | WinRM | The CA certificate to validate against. | |


<a id="bastion"></a>

## Connecting through a Bastion Host with SSH

The `ssh` connection also supports the following arguments to connect
indirectly with a [bastion host](https://en.wikipedia.org/wiki/Bastion_host).

| Argument | Description | Default |
|---------------|-------------|---------|
| `bastion_host` | Setting this enables the bastion Host connection. The provisioner will connect to `bastion_host` first, and then connect from there to `host`. | |
| `bastion_host_key` | The public key from the remote host or the signing CA, used to verify the host connection. | |
| `bastion_port` | The port to use connect to the bastion host. | The value of the `port` field.|
| `bastion_user`| The user for the connection to the bastion host. | The value of the `user` field. |
| `bastion_password` | The password to use for the bastion host. | The value of the `password` field. |
| `bastion_private_key` | The contents of an SSH key file to use for the bastion host. These can be loaded from a file on disk using [the `file` function](/terraform/language/functions/file). | The value of the `private_key` field. |
| `bastion_certificate` |  The contents of a signed CA Certificate. The certificate argument must be used in conjunction with a `bastion_private_key`. These can be loaded from a file on disk using the [the `file` function](/terraform/language/functions/file). |

## Connection through HTTP and SOCKS5 proxies with SSH

The `ssh` connection also supports the following fields to facilitate connections by SSH over HTTP or SOCKS5 proxy.

| Argument | Description | Default |
|---------------|-------------|---------|
| `proxy_scheme` | You can specify one of the following values: `http`, `https`, `socks5` | |
| `proxy_host` | Setting this enables the SSH over HTTP connection. This host will be connected to first, and then the `host` or `bastion_host` connection will be made from there. | |
| `proxy_port` | The port to use connect to the proxy host. | |
| `proxy_user_name` | The username to use connect to the private proxy host. This argument should be specified only if authentication is required for the HTTP Proxy server. | |
| `proxy_user_password` | The password to use connect to the private proxy host. This argument should be specified only if authentication is required for the HTTP Proxy server. | |

## How Provisioners Execute Remote Scripts

Provisioners which execute commands on a remote system via a protocol such as
SSH typically achieve that by uploading a script file to the remote system
and then asking the default shell to execute it. Provisioners use this strategy
because it then allows you to use all of the typical scripting techniques
supported by that shell, including preserving environment variable values
and other context between script statements.

However, this approach does have some consequences which can be relevant in
some unusual situations, even though this is just an implementation detail
in typical use.

Most importantly, there must be a suitable location in the remote filesystem
where the provisioner can create the script file. By default, Terraform
chooses a path containing a random number using the following patterns
depending on how `target_platform` is set:

* `"unix"`: `/tmp/terraform_%RAND%.sh`
* `"windows"`: `C:/windows/temp/terraform_%RAND%.cmd`

In both cases above, the provisioner replaces the sequence `%RAND%` with
some randomly-chosen decimal digits.

Provisioners cannot react directly to remote environment variables such as
`TMPDIR` or use functions like `mktemp` because they run on the system where
Terraform is running, not on the remote system. Therefore if your remote
system doesn't use the filesystem layout expected by these default paths
then you can override it using the `script_path` option in your `connection`
block:

```hcl
connection {
  # ...
  script_path = "H:/terraform-temp/script_%RAND%.sh"
}
```

As with the default patterns, provisioners will replace the sequence `%RAND%`
with randomly-selected decimal digits, to reduce the likelihood of collisions
between multiple provisioners running concurrently.

If your target system is running Windows, we recommend using forward slashes
instead of backslashes, despite the typical convention on Windows, because
the Terraform language uses backslash as the quoted string escape character.

### Executing Scripts using SSH/SCP

When using the SSH protocol, provisioners upload their script files using
the Secure Copy Protocol (SCP), which requires that the remote system have
the `scp` service program installed to act as the server for that protocol.

Provisioners will pass the chosen script path (after `%RAND%`
expansion) directly to the remote `scp` process, which is responsible for
interpreting it. With the default configuration of `scp` as distributed with
OpenSSH, you can place temporary scripts in the home directory of the remote
user by specifying a relative path:

```hcl
connection {
  type = "ssh"
  # ...
  script_path = "terraform_provisioner_%RAND%.sh"
}
```

!> **Warning:** In Terraform v1.0 and earlier, the built-in provisioners
incorrectly passed the `script_path` value to `scp` through a remote shell and
thus allowed it to be subject to arbitrary shell expansion, and thus created an
unintended opportunity for remote code execution. Terraform v1.1 and later
will now correctly quote and escape the script path to ensure that the
remote `scp` process can always interpret it literally. For modules that will
be used with Terraform v1.0 and earlier, avoid using untrusted external
values as part of the `script_path` argument.