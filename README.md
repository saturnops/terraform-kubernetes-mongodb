## MongoDB Kubernetes Terraform Module



<br>
This module deploys a highly available MongoDB cluster on Kubernetes using Helm charts. It offers flexible configurations for volume size, architecture, replica count, backups, restores, and metrics export to Grafana. <br> <br> Users can create a new namespace and configure recovery windows for AWS Secrets Manager, Azure Key Vault, and GCP Secrets Manager. It supports deployment on AWS EKS, Azure AKS, and GCP GKE, allowing for easy and customizable MongoDB setups.

## Supported Versions:

|  MongoDB Helm Chart Version    |     K8s supported version (EKS, AKS & GKE)  |  
| :-----:                       |         :---                |
| **13.1.5**                     |    **1.23,1.24,1.25,1.26,1.27**           |


## Usage Example

```hcl
module "aws" {
  source                             = "saturnops/mongodb/kubernetes//modules/resources/aws"
  environment                        = "prod"
  name                               = "mongodb"
  cluster_name                       = "prod-eks"
  mongodb_custom_credentials_enabled = "true"
  store_password_to_secret_manager   = "true"
  mongodb_custom_credentials_config  = {
    root_user                = "root"
    root_password            = "NCPFUKEMd7rrWuvMAa73"
    metric_exporter_user     = "mongodb_exporter"
    metric_exporter_password = "nvAHhm1uGQNYWVw6ZyAH"
  }
}

module "mongodb" {
  source           = "saturnops/mongodb/kubernetes"
  namespace        = local.namespace
  create_namespace = local.create_namespace
  mongodb_config = {
    name                             = local.name
    namespace                        = local.namespace
    values_yaml                      = file("./helm/values.yaml")
    environment                      = local.environment
    volume_size                      = "10Gi"
    architecture                     = "replicaset"
    custom_databases                 = "['db1', 'db2']"
    custom_databases_usernames       = "['admin', 'admin']"
    custom_databases_passwords       = "['pass1', 'pass2']"
    replica_count                    = 2
    storage_class_name               = "gp2"
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
  root_password                      = local.mongodb_custom_credentials_enabled ? "" : module.aws.root_password
  metric_exporter_password           = local.mongodb_custom_credentials_enabled ? "" : module.aws.metric_exporter_password
  bucket_provider_type               = "s3"
  mongodb_backup_enabled             = true
  iam_role_arn_backup                = module.aws.iam_role_arn_backup
  mongodb_backup_config = {
    bucket_uri           = "s3://mongo-demo-backup"
    s3_bucket_region     = "us-east-2"
    cron_for_full_backup = "* * * * *"
  }
  mongodb_restore_enabled = true
  iam_role_arn_restore    = module.aws.iam_role_arn_restore
  mongodb_restore_config = {
    bucket_uri       = "s3://mongo-demo-backup/mongodumpfull_20230523_092110.gz"
    s3_bucket_region = "us-east-2"
    file_name        = "mongodumpfull_20230523_092110.gz"
  }
  mongodb_exporter_enabled = true
}


```
- Refer [AWS examples](https://github.com/saturnops/terraform-kubernetes-mongodb/tree/main/examples/complete/aws) for more details.
- Refer [Azure examples](https://github.com/saturnops/terraform-kubernetes-mongodb/tree/main/examples/complete/azure) for more details.
- Refer [GCP examples](https://github.com/saturnops/terraform-kubernetes-mongodb/tree/main/examples/complete/gcp) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/saturnops/terraform-kubernetes-mongodb/blob/main/IAM.md)

## Important Notes
  1. In order to enable the exporter, it is required to deploy Prometheus/Grafana first.
  2. The exporter is a tool that extracts metrics data from an application or system and makes it available to be scraped by Prometheus.
  3. Prometheus is a monitoring system that collects metrics data from various sources, including exporters, and stores it in a time-series database.
  4. Grafana is a data visualization and dashboard tool that works with Prometheus and other data sources to display the collected metrics in a user-friendly way.
  5. To deploy Prometheus/Grafana, please follow the installation instructions for each tool in their respective documentation.
  6. Once Prometheus and Grafana are deployed, the exporter can be configured to scrape metrics data from your application or system and send it to Prometheus.
  7. Finally, you can use Grafana to create custom dashboards and visualize the metrics data collected by Prometheus.
  8. This module is compatible with EKS, AKS & GKE which is great news for users deploying the module on an AWS, Azure & GCP cloud. Review the module's documentation, meet specific configuration requirements, and test thoroughly after deployment to ensure everything works as expected.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws"></a> [aws](#module\_aws) | saturnops/mongodb/kubernetes//provider/aws | n/a |
| <a name="module_gcp"></a> [gcp](#module\_gcp) | saturnops/mongodb/kubernetes//provider/gcp | n/a |
| <a name="module_azure"></a> [azure](#module\_azure) | saturnops/mongodb/kubernetes//provider/azure | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.mongodb](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_backup](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_restore](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.mongodb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_password.mongodb_exporter_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_version"></a> [app\_version](#input\_app\_version) | Version of the Mongodb application that will be deployed. | `string` | `"5.0.8-debian-10-r9"` | no |
| <a name="input_bucket_provider_type"></a> [bucket\_provider\_type](#input\_bucket\_provider\_type) | Choose what type of provider you want (s3, gcs) | `string` | `"gcs"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the Mongodb chart that will be used to deploy Mongodb application. | `string` | `"13.1.5"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the name of the EKS cluster to deploy the Mongodb application on. | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace. | `string` | `true` | no |
| <a name="input_iam_role_arn_backup"></a> [iam\_role\_arn\_backup](#input\_iam\_role\_arn\_backup) | IAM role ARN for backup (AWS) | `string` | `""` | no |
| <a name="input_iam_role_arn_restore"></a> [iam\_role\_arn\_restore](#input\_iam\_role\_arn\_restore) | IAM role ARN for restore (AWS) | `string` | `""` | no |
| <a name="input_metric_exporter_pasword"></a> [metric\_exporter\_pasword](#input\_metric\_exporter\_pasword) | Metric exporter password for MongoDB | `string` | `""` | no |
| <a name="input_mongodb_backup_config"></a> [mongodb\_backup\_config](#input\_mongodb\_backup\_config) | Configuration options for Mongodb database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups. | `any` | <pre>{<br>  "bucket_uri": "",<br>  "cron_for_full_backup": "*/5 * * * *",<br>  "s3_bucket_region": "us-east-2"<br>}</pre> | no |
| <a name="input_mongodb_backup_enabled"></a> [mongodb\_backup\_enabled](#input\_mongodb\_backup\_enabled) | Specifies whether to enable backups for Mongodb database. | `bool` | `false` | no |
| <a name="input_mongodb_config"></a> [mongodb\_config](#input\_mongodb\_config) | Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values. | `any` | <pre>{<br>  "architecture": "",<br>  "environment": "",<br>  "name": "",<br>  "replica_count": 2,<br>  "storage_class_name": "",<br>  "store_password_to_secret_manager": true,<br>  "values_yaml": "",<br>  "volume_size": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_config"></a> [mongodb\_custom\_credentials\_config](#input\_mongodb\_custom\_credentials\_config) | Specify the configuration settings for Mongodb to pass custom credentials during creation. | `any` | <pre>{<br>  "metric_exporter_password": "",<br>  "metric_exporter_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_enabled"></a> [mongodb\_custom\_credentials\_enabled](#input\_mongodb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MongoDB database. | `bool` | `false` | no |
| <a name="input_mongodb_exporter_config"></a> [mongodb\_exporter\_config](#input\_mongodb\_exporter\_config) | Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana. | `any` | <pre>{<br>  "version": "2.9.0"<br>}</pre> | no |
| <a name="input_mongodb_exporter_enabled"></a> [mongodb\_exporter\_enabled](#input\_mongodb\_exporter\_enabled) | Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana. | `bool` | `false` | no |
| <a name="input_mongodb_restore_config"></a> [mongodb\_restore\_config](#input\_mongodb\_restore\_config) | Configuration options for restoring dump to the Mongodb database. | `any` | <pre>{<br>  "bucket_uri": "s3://mymongo/mongodumpfull_20230424_112501.gz",<br>  "file_name": "",<br>  "s3_bucket_region": "us-east-2"<br>}</pre> | no |
| <a name="input_mongodb_restore_enabled"></a> [mongodb\_restore\_enabled](#input\_mongodb\_restore\_enabled) | Specifies whether to enable restoring dump to the Mongodb database. | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the Mongodb deployment will be deployed. | `string` | `"mongodb"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | `""` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery. | `number` | `0` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Azure region | `string` | `"East US"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure Resource Group name | `string` | `""` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Azure storage account name | `string` | `""` | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | Root password for MongoDB | `string` | `""` | no |
| <a name="input_service_account_backup"></a> [service\_account\_backup](#input\_service\_account\_backup) | Service account for backup (GCP) | `string` | `""` | no |
| <a name="input_service_account_restore"></a> [service\_account\_restore](#input\_service\_account\_restore) | Service account for restore (GCP) | `string` | `""` | no |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mongodb_credential"></a> [mongodb\_credential](#output\_mongodb\_credential) | MongoDB credentials used for accessing the MongoDB database. |
| <a name="output_mongodb_endpoints"></a> [mongodb\_endpoints](#output\_mongodb\_endpoints) | MongoDB endpoints in the Kubernetes cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->






##           





Please give our GitHub repository a ⭐️ to show your support and increase its visibility.





