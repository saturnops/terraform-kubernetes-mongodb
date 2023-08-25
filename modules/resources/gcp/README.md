# gcp

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.secretadmin_backup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.secretadmin_restore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.service_account_token_creator_backup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.service_account_token_creator_restore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_secret_manager_secret.mongo-secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.mongo-secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.mongo_backup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.mongo_restore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.pod_identity_backup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.pod_identity_restore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [random_password.mongodb_exporter_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the infrastructure is being deployed (e.g., production, staging, development) | `string` | `"test"` | no |
| <a name="input_gcp_gsa_backup_name"></a> [gcp\_gsa\_backup\_name](#input\_gcp\_gsa\_backup\_name) | Google Cloud Service Account name for backup | `string` | `"mongo-backup"` | no |
| <a name="input_gcp_gsa_restore_name"></a> [gcp\_gsa\_restore\_name](#input\_gcp\_gsa\_restore\_name) | Google Cloud Service Account name for restore | `string` | `"mongo-restore"` | no |
| <a name="input_gcp_ksa_backup_name"></a> [gcp\_ksa\_backup\_name](#input\_gcp\_ksa\_backup\_name) | Google Kubernetes Service Account name for backup | `string` | `"sa-mongo-backup"` | no |
| <a name="input_gcp_ksa_restore_name"></a> [gcp\_ksa\_restore\_name](#input\_gcp\_ksa\_restore\_name) | Google Kubernetes Service Account name for restore | `string` | `"sa-mongo-restore"` | no |
| <a name="input_mongodb_custom_credentials_config"></a> [mongodb\_custom\_credentials\_config](#input\_mongodb\_custom\_credentials\_config) | Specify the configuration settings for Mongodb to pass custom credentials during creation. | `any` | <pre>{<br>  "metric_exporter_password": "",<br>  "metric_exporter_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_enabled"></a> [mongodb\_custom\_credentials\_enabled](#input\_mongodb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MongoDB database. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name identifier for module to be added as suffix to resources | `string` | `"test"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | `""` | no |
| <a name="input_store_password_to_secret_manager"></a> [store\_password\_to\_secret\_manager](#input\_store\_password\_to\_secret\_manager) | Specifies whether to store the credentials in GCP secret manager. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#output\_metric\_exporter\_pasword) | mongodb\_exporter user's password of MongoDB |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | Root user's password of MongoDB |
| <a name="output_service_account_backup"></a> [service\_account\_backup](#output\_service\_account\_backup) | Google Cloud Service Account name for backup |
| <a name="output_service_account_restore"></a> [service\_account\_restore](#output\_service\_account\_restore) | Google Cloud Service Account name for restore |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
