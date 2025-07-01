# Install Terraform

## Linux

### ubuntu/debian

- Ensure that your system is up to date and you have installed the `gnupg`, `software-properties-common`, and `curl` packages installed. You will use these packages to verify HashiCorp's GPG signature and install HashiCorp's Debian package repository.

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

1. Install the HashiCorp [`GPG key`](https://apt.releases.hashicorp.com/gpg).

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

```

2. Verify the key's fingerprint.

```bash
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

```

3. The gpg command will report the key fingerprint:
   > /usr/share/keyrings/hashicorp-archive-keyring.gpg
   > `Tip`: Refer to the [`Official Packaging Guide`](https://www.hashicorp.com/official-packaging-guide) for the latest public signing key. You can also verify the key on [`Security at HashiCorp`](https://www.hashicorp.com/security) under Linux Package Checksum Verification.
4. Add the official HashiCorp repository to your system. The lsb_release -cs command finds the distribution release codename for your current system, such as buster, groovy, or sid.

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

5. Download the package information from HashiCorp.

```bash
sudo apt update
```

6. Install Terraform from the new repository.

```bash
sudo apt-get install terraform
```

> `Tip`: Now that you have added the HashiCorp repository, you can install Vault, Consul, Nomad and Packer with the same command. 7. Verify the installation

```bash
terraform -help
```

---

Add any subcommand to terraform -help to learn more about what it does and available options.

```bash
terraform -help plan
```

`O/P`

```bash
terraform -help plan
Usage: terraform [global options] plan [options]

  Generates a speculative execution plan, showing what actions Terraform
  would take to apply the current configuration. This command will not
  actually perform the planned actions.

  You can optionally save the plan to a file, which you can then pass to
  the "apply" command to perform exactly the actions described in the plan.

Plan Customization Options:

  The following options customize how Terraform will produce its plan. You
  can also use these options when you run "terraform apply" without passing
  it a saved plan, in order to plan and apply in a single command.

  -destroy            Select the "destroy" planning mode, which creates a plan
                      to destroy all objects currently managed by this
                      Terraform configuration instead of the usual behavior.

  -refresh-only       Select the "refresh only" planning mode, which checks
                      whether remote objects still match the outcome of the
                      most recent Terraform apply but does not propose any
                      actions to undo any changes made outside of Terraform.

  -refresh=false      Skip checking for external changes to remote objects
                      while creating the plan. This can potentially make
                      planning faster, but at the expense of possibly planning
                      against a stale record of the remote system state.

  -replace=resource   Force replacement of a particular resource instance using
                      its resource address. If the plan would've normally
                      produced an update or no-op action for this instance,
                      Terraform will plan to replace it instead. You can use
                      this option multiple times to replace more than one object.

  -target=resource    Limit the planning operation to only the given module,
                      resource, or resource instance and all of its
                      dependencies. You can use this option multiple times to
                      include more than one object. This is for exceptional
                      use only.

  -var 'foo=bar'      Set a value for one of the input variables in the root
                      module of the configuration. Use this option more than
                      once to set more than one variable.

  -var-file=filename  Load variable values from the given file, in addition
                      to the default files terraform.tfvars and *.auto.tfvars.
                      Use this option more than once to include more than one
                      variables file.

Other Options:

  -compact-warnings          If Terraform produces any warnings that are not
                             accompanied by errors, shows them in a more compact
                             form that includes only the summary messages.

  -detailed-exitcode         Return detailed exit codes when the command exits.
                             This will change the meaning of exit codes to:
                             0 - Succeeded, diff is empty (no changes)
                             1 - Errored
                             2 - Succeeded, there is a diff

  -generate-config-out=path  (Experimental) If import blocks are present in
                             configuration, instructs Terraform to generate HCL
                             for any imported resources not already present. The
                             configuration is written to a new file at PATH,
                             which must not already exist. Terraform may still
                             attempt to write configuration if the plan errors.

  -input=true                Ask for input for variables if not directly set.

  -lock=false                Don't hold a state lock during the operation. This
                             is dangerous if others might concurrently run
                             commands against the same workspace.

  -lock-timeout=0s           Duration to retry a state lock.

  -no-color                  If specified, output won't contain any color.

  -out=path                  Write a plan file to the given path. This can be
                             used as input to the "apply" command.

  -parallelism=n             Limit the number of concurrent operations. Defaults
                             to 10.

  -state=statefile           A legacy option used for the local backend only.
                             See the local backend's documentation for more
                             information.
```

---

## Troubleshoot

If you get an error that terraform could not be found, your PATH environment variable was not set up properly. Please go back and ensure that your PATH variable contains the directory where Terraform was installed.

[`Installation Guide on different machine`](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
