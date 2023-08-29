output "service_account_backup" {
  value       = google_service_account.mongo_backup.email
  description = "Google Cloud Service Account name for backup"
}

output "service_account_restore" {
  value       = google_service_account.mongo_restore.email
  description = "Google Cloud Service Account name for restore"
}

output "root_password" {
  value       = var.mongodb_custom_credentials_enabled ? null : nonsensitive(random_password.mongodb_root_password[0].result)
  description = "Root user's password of MongoDB"
}

output "metric_exporter_pasword" {
  value       = var.mongodb_custom_credentials_enabled ? null : nonsensitive(random_password.mongodb_exporter_password[0].result)
  description = "mongodb_exporter user's password of MongoDB"
}
