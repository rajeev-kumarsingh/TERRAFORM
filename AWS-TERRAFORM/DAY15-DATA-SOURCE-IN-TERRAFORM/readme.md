# Data source in terraform

- Data sources allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.
- Terraform data sources let you dynamically fetch data from APIs or other Terraform state backends. Examples of data sources include machine image IDs from a cloud provider or Terraform outputs from other configurations.
- Data sources make your configuration more flexible and dynamic and let you reference values from other configurations, helping you scope your configuration while still referencing any dependent resource attributes.
- n HCP Terraform, workspaces let you share data between workspaces.
- In this tutorial, you will use data sources to make your configuration more dynamic. First, you will use Terraform to create an AWS VPC and security groups. Next, you will use the aws_availability_zones data source to make your configuration deployable across any region. You will then deploy application infrastructure defined by a separate Terraform configuration, and use the terraform_remote_state data source to query information about your VPC. Finally, you will use the aws_ami data source to configure the correct AMI for the current region.

# Documentation to follow for data-source

[data-source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources)
