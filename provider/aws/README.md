# aws

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.mongo_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.mongo_restore_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_secretsmanager_secret.mongodb_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the name of the EKS cluster to deploy the Mongodb application on. | `string` | `""` | no |
| <a name="input_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#input\_metric\_exporter\_pasword) | Password for the mongo\_exporter user | `string` | n/a | yes |
| <a name="input_mongodb_config"></a> [mongodb\_config](#input\_mongodb\_config) | Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values. | `any` | <pre>{<br>  "architecture": "",<br>  "environment": "",<br>  "name": "",<br>  "replica_count": 2,<br>  "storage_class_name": "",<br>  "values_yaml": "",<br>  "volume_size": ""<br>}</pre> | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the Mongodb deployment will be deployed. | `string` | `"mongodb"` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery. | `number` | `0` | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | Root user password for MySQL | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn_backup"></a> [iam\_role\_arn\_backup](#output\_iam\_role\_arn\_backup) | IAM role arn for mongo backup |
| <a name="output_iam_role_arn_restore"></a> [iam\_role\_arn\_restore](#output\_iam\_role\_arn\_restore) | IAM role arn for mongo restore |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
