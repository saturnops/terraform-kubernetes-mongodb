## MongoDB Kubernetes Terraform Module



<br>

## Usage Example

```hcl
module "mongodb" {
  source                   = "../../"
  mongodb_backup_enabled   = true
  mongodb_exporter_enabled = true
  cluster_name             = "cluster_name"
  mongodb_config       = {
    name               = "skaf"
    environment        = "prod"
    volume_size        = "10Gi"
    architecture       = "replicaset"
    replica_count      = 2
    storage_class_name = "gp2"
  }
  mongodb_backup_config   = {
    s3_bucket_uri         = "s3://bucketname"
    aws_access_key_id     = "aws_access_key_id"
    aws_secret_access_key = "aws_secret_access_key"
    s3_bucket_region      = "bucket_region"
    cron_for_full_backup  = "* * * * *"
  }
}


```
Refer [examples](https://github.com/sq-ia/terraform-kubernetes-mongodb/tree/main/examples/complete) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/sq-ia/terraform-kubernetes-mongodb/blob/main/IAM.md)

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
| [aws_secretsmanager_secret.mongodb_user_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [helm_release.mongodb](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_backup](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.mongodb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_password.mongodb_exporter_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_version"></a> [app\_version](#input\_app\_version) | Enter app version of application | `string` | `"5.0.8-debian-10-r9"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Enter chart version of application | `string` | `"13.1.5"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | `""` | no |
| <a name="input_mongodb_backup_config"></a> [mongodb\_backup\_config](#input\_mongodb\_backup\_config) | Mongodb Backup configurations | `any` | <pre>{<br>  "aws_access_key_id": "",<br>  "aws_secret_access_key": "",<br>  "cron_for_full_backup": "*/5 * * * *",<br>  "s3_bucket_region": "us-east-2",<br>  "s3_bucket_uri": ""<br>}</pre> | no |
| <a name="input_mongodb_backup_enabled"></a> [mongodb\_backup\_enabled](#input\_mongodb\_backup\_enabled) | Set true to enable mongodb backups | `bool` | `false` | no |
| <a name="input_mongodb_config"></a> [mongodb\_config](#input\_mongodb\_config) | Mongodb configurations | `any` | <pre>{<br>  "architecture": "replicaset",<br>  "environment": "dev",<br>  "name": "skaf",<br>  "replica_count": 2,<br>  "storage_class_name": "gp2",<br>  "values_yaml": "",<br>  "volume_size": "50Gi"<br>}</pre> | no |
| <a name="input_mongodb_exporter_config"></a> [mongodb\_exporter\_config](#input\_mongodb\_exporter\_config) | Mongodb exporter configuration | `any` | <pre>{<br>  "version": "2.9.0"<br>}</pre> | no |
| <a name="input_mongodb_exporter_enabled"></a> [mongodb\_exporter\_enabled](#input\_mongodb\_exporter\_enabled) | Set true to deploy mongodb exporters to get metrics in grafana | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Enter namespace name | `string` | `"mongodb"` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mongodb_endpoint"></a> [mongodb\_endpoint](#output\_mongodb\_endpoint) | n/a |
| <a name="output_mongodb_port"></a> [mongodb\_port](#output\_mongodb\_port) | Mongodb Port |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->






##           





Please give our GitHub repository a ⭐️ to show your support and increase its visibility.




