# Azure Mongodb Kubernetes Module
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.mongo-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.mongo-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.pod_identity_assignment_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secretadmin_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secretadmin_restore](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_account_token_creator_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_account_token_creator_restore](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.mongo_backup_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.mongo_restore_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.pod_identity_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_password.mongodb_exporter_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_uai_backup_name"></a> [azure\_uai\_backup\_name](#input\_azure\_uai\_backup\_name) | Azure User Assigned Identity name for backup | `string` | `"mongo-backup"` | no |
| <a name="input_azure_uai_pod_identity_backup_name"></a> [azure\_uai\_pod\_identity\_backup\_name](#input\_azure\_uai\_pod\_identity\_backup\_name) | Azure User Assigned Identity name for pod identity backup | `string` | `"pod-identity-backup"` | no |
| <a name="input_azure_uai_pod_identity_restore_name"></a> [azure\_uai\_pod\_identity\_restore\_name](#input\_azure\_uai\_pod\_identity\_restore\_name) | Azure User Assigned Identity name for pod identity restore | `string` | `"pod-identity-restore"` | no |
| <a name="input_azure_uai_restore_name"></a> [azure\_uai\_restore\_name](#input\_azure\_uai\_restore\_name) | Azure User Assigned Identity name for restore | `string` | `"mongo-restore"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the infrastructure is being deployed (e.g., production, staging, development) | `string` | `"test"` | no |
| <a name="input_mongodb_config"></a> [mongodb\_config](#input\_mongodb\_config) | Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values. | `any` | <pre>{<br>  "architecture": "",<br>  "environment": "",<br>  "name": "",<br>  "replica_count": 2,<br>  "storage_class_name": "",<br>  "store_password_to_secret_manager": true,<br>  "values_yaml": "",<br>  "volume_size": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_config"></a> [mongodb\_custom\_credentials\_config](#input\_mongodb\_custom\_credentials\_config) | Specify the configuration settings for Mongodb to pass custom credentials during creation. | `any` | <pre>{<br>  "metric_exporter_password": "",<br>  "metric_exporter_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_enabled"></a> [mongodb\_custom\_credentials\_enabled](#input\_mongodb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MongoDB database. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of all the resources | `string` | `""` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Azure region | `string` | `"East US"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure Resource Group name | `string` | `""` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Azure storage account name | `string` | `""` | no |
| <a name="input_store_password_to_secret_manager"></a> [store\_password\_to\_secret\_manager](#input\_store\_password\_to\_secret\_manager) | Specifies whether to store the credentials in GCP secret manager. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_account_backup"></a> [az\_account\_backup](#output\_az\_account\_backup) | Azure User Assigned Identity for backup |
| <a name="output_az_account_restore"></a> [az\_account\_restore](#output\_az\_account\_restore) | Azure User Assigned Identity for restore |
| <a name="output_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#output\_metric\_exporter\_pasword) | mongodb\_exporter user's password of MongoDB |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | Root user's password of MongoDB |
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.mongo-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.mongo-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.pod_identity_assignment_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secretadmin_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secretadmin_restore](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_account_token_creator_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_account_token_creator_restore](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.mongo_backup_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.mongo_restore_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.pod_identity_backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_password.mongodb_exporter_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_uai_backup_name"></a> [azure\_uai\_backup\_name](#input\_azure\_uai\_backup\_name) | Azure User Assigned Identity name for backup | `string` | `"mongo-backup"` | no |
| <a name="input_azure_uai_pod_identity_backup_name"></a> [azure\_uai\_pod\_identity\_backup\_name](#input\_azure\_uai\_pod\_identity\_backup\_name) | Azure User Assigned Identity name for pod identity backup | `string` | `"pod-identity-backup"` | no |
| <a name="input_azure_uai_pod_identity_restore_name"></a> [azure\_uai\_pod\_identity\_restore\_name](#input\_azure\_uai\_pod\_identity\_restore\_name) | Azure User Assigned Identity name for pod identity restore | `string` | `"pod-identity-restore"` | no |
| <a name="input_azure_uai_restore_name"></a> [azure\_uai\_restore\_name](#input\_azure\_uai\_restore\_name) | Azure User Assigned Identity name for restore | `string` | `"mongo-restore"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the infrastructure is being deployed (e.g., production, staging, development) | `string` | `"test"` | no |
| <a name="input_mongodb_config"></a> [mongodb\_config](#input\_mongodb\_config) | Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values. | `any` | <pre>{<br>  "architecture": "",<br>  "environment": "",<br>  "name": "",<br>  "replica_count": 2,<br>  "storage_class_name": "",<br>  "store_password_to_secret_manager": true,<br>  "values_yaml": "",<br>  "volume_size": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_config"></a> [mongodb\_custom\_credentials\_config](#input\_mongodb\_custom\_credentials\_config) | Specify the configuration settings for Mongodb to pass custom credentials during creation. | `any` | <pre>{<br>  "metric_exporter_password": "",<br>  "metric_exporter_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_enabled"></a> [mongodb\_custom\_credentials\_enabled](#input\_mongodb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MongoDB database. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of all the resources | `string` | `""` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Azure region | `string` | `"East US"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure Resource Group name | `string` | `""` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Azure storage account name | `string` | `""` | no |
| <a name="input_store_password_to_secret_manager"></a> [store\_password\_to\_secret\_manager](#input\_store\_password\_to\_secret\_manager) | Specifies whether to store the credentials in GCP secret manager. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_account_backup"></a> [az\_account\_backup](#output\_az\_account\_backup) | Azure User Assigned Identity for backup |
| <a name="output_az_account_restore"></a> [az\_account\_restore](#output\_az\_account\_restore) | Azure User Assigned Identity for restore |
| <a name="output_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#output\_metric\_exporter\_pasword) | mongodb\_exporter user's password of MongoDB |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | Root user's password of MongoDB |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
