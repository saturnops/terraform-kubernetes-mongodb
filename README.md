## MongoDB Kubernetes Terraform Module



<br>
This module is for deploying a highly available MongoDB cluster on Kubernetes using Helm charts. This module provides flexible configuration options to customize the MongoDB deployment such as setting the volume size, architecture, replica count, and more. It also includes options to enable MongoDB backups and restores, and to deploy MongoDB exporters for getting metrics in Grafana. Additionally, this module provides options to create a new namespace, and to configure recovery windows for AWS Secrets Manager. With this module, users can easily deploy a highly available MongoDB cluster on Kubernetes with the flexibility to customize their configurations according to their needs.

## Supported Versions:

|  MongoDB Helm Chart Version    |     K8s supported version   |  
| :-----:                       |         :---                |
| **13.1.5**                     |    **1.23,1.24,1.25**           |


## Usage Example

```hcl
module "mongodb" {
  source                   = "saturnops/mongodb/kubernetes"
  cluster_name             = "prod-cluster"
  mongodb_config = {
  name                             = "mongo"
  values_yaml                      = ""
  environment                      = "prod"
  volume_size                      = "10Gi"
  architecture                     = "replicaset"
  replica_count                    = 2
  storage_class_name               = "gp3"
  store_password_to_secret_manager = true
  }
  mongodb_backup_enabled   = true
  mongodb_backup_config = {
    s3_bucket_uri         = ""
    s3_bucket_region      = ""
    cron_for_full_backup  = "* * * * *"
  }

  mongodb_restore_enabled = true
  mongodb_restore_config = {
    s3_bucket_uri              = ""
    s3_bucket_region           = ""
    full_restore_enable        = true
    file_name_full             = ""
    incremental_restore_enable = false
    file_name_incremental      = ""
  }
  mongodb_exporter_enabled = true  
}


```
Refer [examples](https://github.com/saturnops/terraform-kubernetes-mongodb/tree/main/examples/complete) for more details.

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
  8. This module is compatible with EKS version 1.23, which is great news for users deploying the module on an EKS cluster running that version. Review the module's documentation, meet specific configuration requirements, and test thoroughly after deployment to ensure everything works as expected.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
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
| [helm_release.mongodb](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_backup](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_restore](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.mongodb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_password.mongodb_exporter_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_version"></a> [app\_version](#input\_app\_version) | Version of the Mongodb application that will be deployed. | `string` | `"5.0.8-debian-10-r9"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the Mongodb chart that will be used to deploy Mongodb application. | `string` | `"13.1.5"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the name of the EKS cluster to deploy the Mongodb application on. | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace. | `string` | `true` | no |
| <a name="input_mongodb_backup_config"></a> [mongodb\_backup\_config](#input\_mongodb\_backup\_config) | Configuration options for Mongodb database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups. | `any` | <pre>{<br>  "cron_for_full_backup": "*/5 * * * *",<br>  "s3_bucket_region": "us-east-2",<br>  "s3_bucket_uri": ""<br>}</pre> | no |
| <a name="input_mongodb_backup_enabled"></a> [mongodb\_backup\_enabled](#input\_mongodb\_backup\_enabled) | Specifies whether to enable backups for Mongodb database. | `bool` | `false` | no |
| <a name="input_mongodb_config"></a> [mongodb\_config](#input\_mongodb\_config) | Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values. | `any` | <pre>{<br>  "architecture": "",<br>  "environment": "",<br>  "name": "",<br>  "replica_count": 2,<br>  "storage_class_name": "",<br>  "store_password_to_secret_manager": true,<br>  "values_yaml": "",<br>  "volume_size": ""<br>}</pre> | no |
| <a name="input_mongodb_exporter_config"></a> [mongodb\_exporter\_config](#input\_mongodb\_exporter\_config) | Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana. | `any` | <pre>{<br>  "version": "2.9.0"<br>}</pre> | no |
| <a name="input_mongodb_exporter_enabled"></a> [mongodb\_exporter\_enabled](#input\_mongodb\_exporter\_enabled) | Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana. | `bool` | `false` | no |
| <a name="input_mongodb_restore_config"></a> [mongodb\_restore\_config](#input\_mongodb\_restore\_config) | Configuration options for restoring dump to the Mongodb database. | `any` | <pre>{<br>  "file_name_full": "",<br>  "file_name_incremental": "",<br>  "full_restore_enable": false,<br>  "incremental_restore_enable": false,<br>  "s3_bucket_region": "us-east-2",<br>  "s3_bucket_uri": "s3://mymongo/mongodumpfull_20230424_112501.gz"<br>}</pre> | no |
| <a name="input_mongodb_restore_enabled"></a> [mongodb\_restore\_enabled](#input\_mongodb\_restore\_enabled) | Specifies whether to enable restoring dump to the Mongodb database. | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the Mongodb deployment will be deployed. | `string` | `"mongodb"` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mongodb_credential"></a> [mongodb\_credential](#output\_mongodb\_credential) | MongoDB\_Info |
| <a name="output_mongodb_endpoints"></a> [mongodb\_endpoints](#output\_mongodb\_endpoints) | MongoDB\_Info |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->






##           





Please give our GitHub repository a ⭐️ to show your support and increase its visibility.





