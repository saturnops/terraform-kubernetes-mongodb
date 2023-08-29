# aws

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.mongo_backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.mongo_restore_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_secretsmanager_secret.mongodb_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.mongodb_exporter_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the name of the EKS cluster to deploy the Mongodb application on. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the infrastructure is being deployed (e.g., production, staging, development) | `string` | `"test"` | no |
| <a name="input_mongodb_custom_credentials_config"></a> [mongodb\_custom\_credentials\_config](#input\_mongodb\_custom\_credentials\_config) | Specify the configuration settings for Mongodb to pass custom credentials during creation. | `any` | <pre>{<br>  "metric_exporter_password": "",<br>  "metric_exporter_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_enabled"></a> [mongodb\_custom\_credentials\_enabled](#input\_mongodb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MongoDB database. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name identifier for module to be added as suffix to resources | `string` | `"test"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the Mongodb deployment will be deployed. | `string` | `"mongodb"` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery. | `number` | `0` | no |
| <a name="input_store_password_to_secret_manager"></a> [store\_password\_to\_secret\_manager](#input\_store\_password\_to\_secret\_manager) | Specifies whether to store the credentials in GCP secret manager. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn_backup"></a> [iam\_role\_arn\_backup](#output\_iam\_role\_arn\_backup) | IAM role arn for mongo backup |
| <a name="output_iam_role_arn_restore"></a> [iam\_role\_arn\_restore](#output\_iam\_role\_arn\_restore) | IAM role arn for mongo restore |
| <a name="output_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#output\_metric\_exporter\_pasword) | mongodb\_exporter user's password of MongoDB |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | Root user's password of MongoDB |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
