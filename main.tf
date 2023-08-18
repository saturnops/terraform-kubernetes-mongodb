locals {
  arbiterValue = var.mongodb_config.replica_count % 2 == 0 ? true : false
}

resource "random_password" "mongodb_root_password" {
  count   = var.mongodb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "random_password" "mongodb_exporter_password" {
  count   = var.mongodb_custom_credentials_enabled ? 0 : 1
  length  = 20
  special = false
}

resource "kubernetes_namespace" "mongodb" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {}
    name        = var.namespace
  }
}

resource "helm_release" "mongodb" {
  depends_on = [kubernetes_namespace.mongodb]
  name       = "mongodb"
  chart      = "mongodb"
  version    = var.chart_version
  timeout    = 600
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  values = [
    templatefile("${path.module}/helm/values/mongodb/values.yaml", {
      namespace                  = var.namespace,
      app_version                = var.app_version,
      volume_size                = var.mongodb_config.volume_size,
      architecture               = var.mongodb_config.architecture,
      replicacount               = var.mongodb_config.replica_count,
      arbiterValue               = local.arbiterValue,
      storage_class_name         = var.mongodb_config.storage_class_name,
      mongodb_exporter_password  = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.metric_exporter_password : random_password.mongodb_exporter_password[0].result,
      mongodb_root_user_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : random_password.mongodb_root_password[0].result
    }),
    var.mongodb_config.values_yaml
  ]
}

module "aws" {
  source                             = "./provider/aws"
  count                              = var.bucket_provider_type == "s3" ? 1 : 0
  mongodb_config                     = var.mongodb_config
  recovery_window_aws_secret         = var.recovery_window_aws_secret
  cluster_name                       = var.cluster_name
  mongodb_custom_credentials_enabled = var.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = var.mongodb_custom_credentials_config
}

module "gcp" {
  source                             = "./provider/gcp"
  count                              = var.bucket_provider_type == "gcs" ? 1 : 0
  project_id                         = var.project_id
  environment                        = var.mongodb_config.environment
  mongodb_config                     = var.mongodb_config
  mongodb_custom_credentials_enabled = var.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = var.mongodb_custom_credentials_config
}

resource "helm_release" "mongodb_backup" {
  depends_on = [helm_release.mongodb]
  count      = var.mongodb_backup_enabled ? 1 : 0
  name       = "mongodb-backup"
  chart      = "${path.module}/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/backup/values.yaml", {
      mongodb_root_user_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : random_password.mongodb_root_password[0].result,
      bucket_uri                 = var.mongodb_backup_config.bucket_uri,
      s3_bucket_region           = var.bucket_provider_type == "s3" ? var.mongodb_backup_config.s3_bucket_region : "",
      cron_for_full_backup       = var.mongodb_backup_config.cron_for_full_backup,
      bucket_provider_type       = var.bucket_provider_type,
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${module.aws[0].iam_role_arn_backup}" : "iam.gke.io/gcp-service-account: ${module.gcp[0].service_account_backup}"
    })
  ]
}

##DB Dump restore
resource "helm_release" "mongodb_restore" {
  depends_on = [helm_release.mongodb]
  count      = var.mongodb_restore_enabled ? 1 : 0
  name       = "mongodb-restore"
  chart      = "${path.module}/restore"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/restore/values.yaml", {
      mongodb_root_user_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : random_password.mongodb_root_password[0].result,
      bucket_uri                 = var.mongodb_restore_config.bucket_uri,
      file_name                  = var.mongodb_restore_config.file_name,
      s3_bucket_region           = var.bucket_provider_type == "s3" ? var.mongodb_restore_config.s3_bucket_region : "",
      bucket_provider_type       = var.bucket_provider_type,
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${module.aws[0].iam_role_arn_restore}" : "iam.gke.io/gcp-service-account: ${module.gcp[0].service_account_restore}"
    })
  ]
}

resource "helm_release" "mongodb_exporter" {
  depends_on = [helm_release.mongodb]
  count      = var.mongodb_exporter_enabled ? 1 : 0
  name       = "mongodb-exporter"
  chart      = "prometheus-mongodb-exporter"
  version    = var.mongodb_exporter_config.version
  timeout    = 600
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  values = [
    templatefile("${path.module}/helm/values/exporter/values.yaml", {
      mongodb_exporter_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.metric_exporter_password : "${random_password.mongodb_exporter_password[0].result}"
      service_monitor_namespace = var.namespace
    }),
    var.mongodb_config.values_yaml
  ]
}
