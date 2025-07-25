---
page_title: "Provisioner: file"
description: >-
  The `file` provisioner is used to copy files or directories from the machine
  executing Terraform to the newly created resource. The `file` provisioner
  supports both `ssh` and `winrm` type connections.
---

# File Provisioner

The `file` provisioner copies files or directories from the machine
running Terraform to the newly created resource. The `file` provisioner
supports both `ssh` and `winrm` type [connections](/terraform/language/resources/provisioners/connection).

~> **Important:** Use provisioners as a last resort. There are better alternatives for most situations. Refer to
[Declaring Provisioners](/terraform/language/resources/provisioners/syntax) for more details.

## Example usage

```hcl
resource "aws_instance" "web" {
  # ...

  # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }

  # Copies the string in content into /tmp/file.log
  provisioner "file" {
    content     = "ami used: ${self.ami}"
    destination = "/tmp/file.log"
  }

  # Copies the configs.d folder to /etc/configs.d
  provisioner "file" {
    source      = "conf/configs.d"
    destination = "/etc"
  }

  # Copies all files and folders in apps/app1 to D:/IIS/webapp1
  provisioner "file" {
    source      = "apps/app1/"
    destination = "D:/IIS/webapp1"
  }
}
```

-> **Note:** When the `file` provisioner communicates with a Windows system over SSH, you must configure OpenSSH to run the commands with `cmd.exe` and not PowerShell. PowerShell causes file parsing errors because it is incompatible with both Unix shells and the Windows command interpreter.

## Argument Reference

The following arguments are supported:

- `source` - The source file or directory. Specify it either relative to the
  current working directory or as an absolute path.
  This argument cannot be combined with `content`.

- `content` - The direct content to copy on the destination.
  If destination is a file, the content will be written on that file. In case
  of a directory, a file named `tf-file-content` is created inside that
  directory. We recommend using a file as the destination when using `content`.
  This argument cannot be combined with `source`.

- `destination` - (Required) The destination path to write to on the remote
  system. See [Destination Paths](#destination-paths) below for more
  information.

## Destination Paths

The path you provide in the `destination` argument will be evaluated by the
remote system, rather than by Terraform itself. Therefore the valid values
for that argument can vary depending on the operating system and remote access
software running on the target.

When connecting over SSH, the `file` provisioner passes the given destination
path verbatim to the `scp` program on the remote host. By default, OpenSSH's
`scp` implementation runs in the remote user's home directory and so you can
specify a relative path to upload into that home directory, or an absolute
path to upload to some other location. The remote `scp` process will run with
the access level of the user specified in the `connection` block, and so
permissions may prevent writing directly to locations outside of the home
directory.

Because WinRM has no corresponding file transfer protocol, for WinRM
connections the `file` provisioner uses a more complex process:

1. Generate a temporary filename in the directory given in the remote system's
   `TEMP` environment variable, using a pseudorandom UUID for uniqueness.
2. Use sequential generated `echo` commands over WinRM to gradually append
   base64-encoded chunks of the source file to the chosen temporary file.
3. Use an uploaded PowerShell script to read the temporary file, base64-decode,
   and write the raw result into the destination file.

In the WinRM case, the destination path is therefore interpreted by PowerShell
and so you must take care not to use any meta-characters that PowerShell might
interpret. In particular, avoid including any untrusted external input in
your `destination` argument when using WinRM, because it can serve as a vector
for arbitrary PowerShell code execution on the remote system.

Modern Windows systems support running an OpenSSH server, so we strongly
recommend choosing SSH over WinRM whereever possible, and using WinRM only as
a last resort when working with obsolete Windows versions.

## Directory Uploads

The `file` provisioner can upload a complete directory to the remote machine.
When uploading a directory, there are some additional considerations.

When using the `ssh` connection type the destination directory must already
exist. If you need to create it, use a remote-exec provisioner just prior to
the file provisioner in order to create the directory

When using the `winrm` connection type the destination directory will be
created for you if it doesn't already exist.

The existence of a trailing slash on the source path will determine whether the
directory name will be embedded within the destination, or whether the
destination will be created. For example:

- If the source is `/foo` (no trailing slash), and the destination is `/tmp`,
  then the contents of `/foo` on the local machine will be uploaded to
  `/tmp/foo` on the remote machine. The `foo` directory on the remote machine
  will be created by Terraform.

- If the source, however, is `/foo/` (a trailing slash is present), and the
  destination is `/tmp`, then the contents of `/foo` will be uploaded directly
  into `/tmp`.
