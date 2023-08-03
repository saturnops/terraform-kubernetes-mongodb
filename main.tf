locals {
  arbiterValue = var.mongodb_config.replica_count % 2 == 0 ? true : false
  oidc_provider = replace(
    data.aws_eks_cluster.kubernetes_cluster.identity[0].oidc[0].issuer,
    "/^https:///",
    ""
  )
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "kubernetes_cluster" {
  name = var.cluster_name
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

resource "aws_secretsmanager_secret" "mongodb_user_password" {
  count                   = var.mongodb_config.store_password_to_secret_manager ? 1 : 0
  name                    = format("%s/%s/%s", var.mongodb_config.environment, var.mongodb_config.name, "mongodb")
  recovery_window_in_days = var.recovery_window_aws_secret
}

resource "aws_secretsmanager_secret_version" "mongodb_root_password" {
  count     = var.mongodb_config.store_password_to_secret_manager ? 1 : 0
  secret_id = aws_secretsmanager_secret.mongodb_user_password[0].id
  secret_string = var.mongodb_custom_credentials_enabled ? jsonencode(
    {
      "root_user" : "${var.mongodb_custom_credentials_config.root_user}",
      "root_password" : "${var.mongodb_custom_credentials_config.root_password}",
      "metric_exporter_user" : "${var.mongodb_custom_credentials_config.metric_exporter_user}",
      "metric_exporter_password" : "${var.mongodb_custom_credentials_config.metric_exporter_password}"
    }) : jsonencode(
    {
      "root_user" : "root",
      "root_password" : "${random_password.mongodb_root_password[0].result}",
      "metric_exporter_user" : "mongodb_exporter",
      "metric_exporter_password" : "${random_password.mongodb_exporter_password[0].result}"
  })
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

resource "helm_release" "mongodb_backup" {
  depends_on = [helm_release.mongodb]
  count      = var.mongodb_backup_enabled ? 1 : 0
  name       = "mongodb-backup"
  chart      = "${path.module}/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/helm/values/backup/values.yaml", {
      s3_role_arn                = aws_iam_role.mongo_backup_role.arn,
      s3_bucket_uri              = var.mongodb_backup_config.s3_bucket_uri,
      s3_bucket_region           = var.mongodb_backup_config.s3_bucket_region,
      cron_for_full_backup       = var.mongodb_backup_config.cron_for_full_backup,
      mongodb_root_user_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : random_password.mongodb_root_password[0].result
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

resource "aws_iam_role" "mongo_backup_role" {
  name = format("%s-%s-%s", var.cluster_name, var.mongodb_config.name, "mongodb-backup")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" = "sts.amazonaws.com",
            "${local.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:sa-mongo-backup"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "AllowS3PutObject"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:ListBucket",
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
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
      s3_role_arn                = aws_iam_role.mongo_restore_role.arn,
      s3_bucket_uri              = var.mongodb_restore_config.s3_bucket_uri,
      s3_bucket_region           = var.mongodb_restore_config.s3_bucket_region,
      file_name_full             = var.mongodb_restore_config.file_name_full,
      full_restore_enable        = var.mongodb_restore_config.full_restore_enable,
      file_name_incremental      = var.mongodb_restore_config.file_name_incremental,
      incremental_restore_enable = var.mongodb_restore_config.incremental_restore_enable,
      mongodb_root_user_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : random_password.mongodb_root_password[0].result
    })
  ]
}

resource "aws_iam_role" "mongo_restore_role" {
  name = format("%s-%s-%s", var.cluster_name, var.mongodb_config.name, "mongodb-restore")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" = "sts.amazonaws.com",
            "${local.oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:sa-mongo-restore"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "AllowS3PutObject"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:ListBucket",
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:AbortMultipartUpload",
            "s3:ListMultipartUploadParts"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}
