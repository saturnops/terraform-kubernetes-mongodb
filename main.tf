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
  length  = 20
  special = false
}

resource "random_password" "mongodb_exporter_password" {
  length  = 20
  special = false
}

resource "aws_secretsmanager_secret" "mongodb_user_password" {
  name                    = format("%s/%s/%s", var.mongodb_config.environment, var.mongodb_config.name, "mongodb")
  recovery_window_in_days = var.recovery_window_aws_secret
}

resource "aws_secretsmanager_secret_version" "mongodb_root_password" {
  secret_id     = aws_secretsmanager_secret.mongodb_user_password.id
  secret_string = <<EOF
   {
    "root_user": "root",
    "root_password": "${random_password.mongodb_root_password.result}",
    "metric_exporter_user": "mongodb_exporter",
    "metric_exporter_password": "${random_password.mongodb_exporter_password.result}"
   }
EOF
}

resource "kubernetes_namespace" "mongodb" {
  metadata {
    annotations = {}

    name = var.namespace
  }
}

resource "helm_release" "mongodb" {
  depends_on = [kubernetes_namespace.mongodb]

  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = var.namespace
  version    = var.chart_version
  timeout    = 600

  values = [
    templatefile("${path.module}/helm/values/mongodb/values.yaml", {
      app_version                = var.app_version,
      mongodb_root_user_password = random_password.mongodb_root_password.result,
      volume_size                = var.mongodb_config.volume_size,
      architecture               = var.mongodb_config.architecture,
      replicacount               = var.mongodb_config.replica_count,
      mongodb_exporter_password  = random_password.mongodb_exporter_password.result,
      arbiterValue               = local.arbiterValue,
      storage_class_name         = var.mongodb_config.storage_class_name
    }),
    var.mongodb_config.values_yaml
  ]
}

resource "helm_release" "mongodb_backup" {
  depends_on = [helm_release.mongodb]
  count      = var.mongodb_backup_enabled ? 1 : 0
  name       = "mongodb-backup"
  chart      = "${path.module}/backup"
  namespace  = var.namespace
  timeout    = 600

  values = [
    templatefile("${path.module}/helm/values/backup/values.yaml", {
      cron_for_full_backup       = var.mongodb_backup_config.cron_for_full_backup,
      s3_bucket_uri              = var.mongodb_backup_config.s3_bucket_uri,
      s3_bucket_region           = var.mongodb_backup_config.s3_bucket_region,
      aws_access_key_id          = var.mongodb_backup_config.aws_access_key_id,
      aws_secret_access_key      = var.mongodb_backup_config.aws_secret_access_key,
      mongodb_root_user_password = random_password.mongodb_root_password.result,
      s3_role_arn                = aws_iam_role.mongo_backup_role.arn
    })
  ]
}

resource "helm_release" "mongodb_exporter" {
  depends_on = [helm_release.mongodb]
  count      = var.mongodb_exporter_enabled ? 1 : 0
  name       = "mongodb-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-mongodb-exporter"
  namespace  = var.namespace
  version    = var.mongodb_exporter_config.version
  timeout    = 600

  values = [
    templatefile("${path.module}/helm/values/exporter/values.yaml", {
      mongodb_exporter_password = "${random_password.mongodb_exporter_password.result}"
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
            "s3:DeleteObject",
            "s3:PutObject",
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
