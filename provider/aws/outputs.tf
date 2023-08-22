output "iam_role_arn_backup" {
  value       = aws_iam_role.mongo_backup_role.arn
  description = "IAM role arn for mongo backup"
}

output "iam_role_arn_restore" {
  value       = aws_iam_role.mongo_restore_role.arn
  description = "IAM role arn for mongo restore"
}

output "root_password" {
  value       = var.mongodb_custom_credentials_enabled ? null : nonsensitive(random_password.mongodb_root_password[0].result)
  description = "Root user's password of MongoDB"
}

output "metric_exporter_pasword" {
  value       = var.mongodb_custom_credentials_enabled ? null : nonsensitive(random_password.mongodb_exporter_password[0].result)
  description = "mongodb_exporter user's password of MongoDB"
}