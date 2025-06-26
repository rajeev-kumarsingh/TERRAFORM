# AWS EMR Virtual Cluster Terraform module

Terraform module which creates AWS EMR Virtual Cluster resources.

Note: you will need to add the `AWSServiceRoleForAmazonEMRContainers` role to the clusters `aws-auth` configmap under the username of `emr-containers`. See below for reference:

```hcl
data "aws_caller_identity" "current" {}

...
  aws_auth_roles = [
    {
      # Required for EMR on EKS virtual cluster
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSServiceRoleForAmazonEMRContainers"
      username = "emr-containers"
    },
  ]
...
```

## Usage

See [`examples`](https://github.com/terraform-aws-modules/terraform-aws-emr/tree/master/examples) directory for working examples to reference:

### Custom

```hcl
module "emr_virtual_cluster" {
  source = "terraform-aws-modules/emr/aws//modules/virtual-cluster"

  name             = "emr-custom"
  create_namespace = true
  namespace        = "emr-custom"

  create_iam_role = true
  s3_bucket_arns = [
    "arn:aws:s3:::/my-elasticmapreduce-bucket",
    "arn:aws:s3:::/my-elasticmapreduce-bucket/*",
  ]
  role_name                     = "emr-custom-role"
  iam_role_use_name_prefix      = false
  iam_role_path                 = "/"
  iam_role_description          = "EMR custom Role"
  iam_role_permissions_boundary = null
  iam_role_additional_policies  = []

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

### Default

```hcl
module "emr_virtual_cluster" {
  source = "terraform-aws-modules/emr/aws//modules/virtual-cluster"

  namespace = "emr-default"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Examples

Examples codified under the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-emr/tree/master/examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Private clusters](https://github.com/terraform-aws-modules/terraform-aws-emr/tree/master/examples/private-cluster) using instance fleet or instance group
- [Public clusters](https://github.com/terraform-aws-modules/terraform-aws-emr/tree/master/examples/private-cluster) using instance fleet or instance group
- [Serverless clusters](https://github.com/terraform-aws-modules/terraform-aws-emr/tree/master/examples/virtual-cluster) running Spark or Hive
- [Studios](https://github.com/terraform-aws-modules/terraform-aws-emr/tree/master/examples/studio) with either IAM or SSO authentication
- [Virtual cluster](https://github.com/terraform-aws-modules/terraform-aws-emr/tree/master/examples/virtual-cluster) running on Amazon EKS

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.83 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.83 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_emrcontainers_virtual_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emrcontainers_virtual_cluster) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_role_binding_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding_v1) | resource |
| [kubernetes_role_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | A map of annotations to add to all Kubernetes resources | `map(string)` | `{}` | no |
| <a name="input_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#input\_cloudwatch\_log\_group\_arn) | ARN of the log group to use for the cluster logs | `string` | `"arn:aws:logs:*:*:*"` | no |
| <a name="input_cloudwatch_log_group_kms_key_id"></a> [cloudwatch\_log\_group\_kms\_key\_id](#input\_cloudwatch\_log\_group\_kms\_key\_id) | If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html) | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name of the log group. If a name is not provided, the default name format used is: `/emr-on-eks-logs/emr-workload/<NAMESPACE>` | `string` | `null` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Number of days to retain log events. Default retention - 7 days | `number` | `7` | no |
| <a name="input_cloudwatch_log_group_skip_destroy"></a> [cloudwatch\_log\_group\_skip\_destroy](#input\_cloudwatch\_log\_group\_skip\_destroy) | Set to 'true' if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state | `bool` | `null` | no |
| <a name="input_cloudwatch_log_group_use_name_prefix"></a> [cloudwatch\_log\_group\_use\_name\_prefix](#input\_cloudwatch\_log\_group\_use\_name\_prefix) | Determines whether the log group name (`cloudwatch_log_group_name`) is used as a prefix | `bool` | `false` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects nearly all resources) | `bool` | `true` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Determines whether a log group is created by this module for the cluster logs. If not, AWS will automatically create one if logging is enabled | `bool` | `true` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Determines whether an IAM role is created for EMR on EKS job execution role | `bool` | `true` | no |
| <a name="input_create_kubernetes_role"></a> [create\_kubernetes\_role](#input\_create\_kubernetes\_role) | Determines whether a Kubernetes role is created for EMR on EKS | `bool` | `true` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Determines whether a Kubernetes namespace is created for EMR on EKS | `bool` | `true` | no |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS cluster ID | `string` | `""` | no |
| <a name="input_iam_role_additional_policies"></a> [iam\_role\_additional\_policies](#input\_iam\_role\_additional\_policies) | Additional policies to be added to the job execution IAM role | `any` | `{}` | no |
| <a name="input_iam_role_description"></a> [iam\_role\_description](#input\_iam\_role\_description) | Description of the job execution role | `string` | `null` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | Job execution IAM role path | `string` | `null` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the job execution IAM role | `string` | `null` | no |
| <a name="input_iam_role_use_name_prefix"></a> [iam\_role\_use\_name\_prefix](#input\_iam\_role\_use\_name\_prefix) | Determines whether the IAM job execution role name (`role_name`) is used as a prefix | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to add to all Kubernetes resources | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EMR on EKS virtual cluster | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for EMR on EKS | `string` | `"emr-containers"` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | OIDC provider ARN for the EKS cluster | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name to use on IAM role created for EMR on EKS job execution role as well as Kubernetes RBAC role | `string` | `null` | no |
| <a name="input_s3_bucket_arns"></a> [s3\_bucket\_arns](#input\_s3\_bucket\_arns) | S3 bucket ARNs for EMR on EKS job execution role to list, get objects, and put objects | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | Arn of cloudwatch log group created |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of cloudwatch log group created |
| <a name="output_job_execution_role_arn"></a> [job\_execution\_role\_arn](#output\_job\_execution\_role\_arn) | IAM role ARN of the job execution role |
| <a name="output_job_execution_role_name"></a> [job\_execution\_role\_name](#output\_job\_execution\_role\_name) | IAM role name of the job execution role |
| <a name="output_job_execution_role_unique_id"></a> [job\_execution\_role\_unique\_id](#output\_job\_execution\_role\_unique\_id) | Stable and unique string identifying the job execution IAM role |
| <a name="output_virtual_cluster_arn"></a> [virtual\_cluster\_arn](#output\_virtual\_cluster\_arn) | ARN of the EMR virtual cluster |
| <a name="output_virtual_cluster_id"></a> [virtual\_cluster\_id](#output\_virtual\_cluster\_id) | ID of the EMR virtual cluster |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-emr/blob/master/LICENSE).
