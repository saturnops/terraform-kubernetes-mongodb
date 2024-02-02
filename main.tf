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
      custom_databases           = var.mongodb_config.custom_databases
      custom_databases_usernames = var.mongodb_config.custom_databases_usernames
      custom_databases_passwords = var.mongodb_config.custom_databases_passwords
      storage_class_name         = var.mongodb_config.storage_class_name,
      mongodb_exporter_password  = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.metric_exporter_password : var.metric_exporter_password,
      mongodb_root_user_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : var.root_password
    }),
    var.mongodb_config.values_yaml
  ]
}

resource "helm_release" "mongodb_backup" {
  depends_on = [helm_release.mongodb]
  count      = var.mongodb_backup_enabled ? 1 : 0
  name       = "mongodb-backup"
  chart      = "${path.module}/modules/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/backup/values.yaml", {
      mongodb_root_user_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : var.root_password,
      bucket_uri                 = var.mongodb_backup_config.bucket_uri,
      s3_bucket_region           = var.bucket_provider_type == "s3" ? var.mongodb_backup_config.s3_bucket_region : "",
      cron_for_full_backup       = var.mongodb_backup_config.cron_for_full_backup,
      bucket_provider_type       = var.bucket_provider_type,
      azure_storage_account_name = var.bucket_provider_type == "azure" ? var.azure_storage_account_name : ""
      azure_storage_account_key  = var.bucket_provider_type == "azure" ? var.azure_storage_account_key : ""
      azure_container_name       = var.bucket_provider_type == "azure" ? var.azure_container_name : ""
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn : ${var.iam_role_arn_backup}" : var.bucket_provider_type == "gcs" ? "iam.gke.io/gcp-service-account: ${var.service_account_backup}" : var.bucket_provider_type == "azure" ? "azure.workload.identity/client-id: ${var.az_account_backup}" : ""
    }),
    var.mongodb_config.values_yaml
  ]
}

##DB Dump restore
resource "helm_release" "mongodb_restore" {
  depends_on = [helm_release.mongodb]
  count      = var.mongodb_restore_enabled ? 1 : 0
  name       = "mongodb-restore"
  chart      = "${path.module}/modules/restore"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/restore/values.yaml", {
      mongodb_root_user_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : var.root_password,
      bucket_uri                 = var.mongodb_restore_config.bucket_uri,
      file_name                  = var.mongodb_restore_config.file_name,
      s3_bucket_region           = var.bucket_provider_type == "s3" ? var.mongodb_restore_config.s3_bucket_region : "",
      bucket_provider_type       = var.bucket_provider_type,
      azure_storage_account_name = var.bucket_provider_type == "azure" ? var.azure_storage_account_name : ""
      azure_storage_account_key  = var.bucket_provider_type == "azure" ? var.azure_storage_account_key : ""
      azure_container_name       = var.bucket_provider_type == "azure" ? var.azure_container_name : ""
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn : ${var.iam_role_arn_restore}" : var.bucket_provider_type == "gcs" ? "iam.gke.io/gcp-service-account: ${var.service_account_restore}" : var.bucket_provider_type == "azure" ? "azure.workload.identity/client-id: ${var.az_account_restore}" : ""
    }),
    var.mongodb_config.values_yaml
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
      mongodb_exporter_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.metric_exporter_password : "${var.metric_exporter_password}"
      service_monitor_namespace = var.namespace
    }),
    var.mongodb_exporter_values
  ]
}
