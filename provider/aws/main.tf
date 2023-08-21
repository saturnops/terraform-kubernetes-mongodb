locals {
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
      "root_password" : "${var.root_password}",
      "metric_exporter_user" : "mongodb_exporter",
      "metric_exporter_password" : "${var.metric_exporter_pasword}"
  })
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


output "iam_role_arn_backup" {
  value       = aws_iam_role.mongo_backup_role.arn
  description = "IAM role arn for mongo backup"
}

output "iam_role_arn_restore" {
  value       = aws_iam_role.mongo_restore_role.arn
  description = "IAM role arn for mongo restore"
}
