output "az_account_backup" {
  value       = azurerm_user_assigned_identity.mongo_backup_identity.client_id
  description = "Azure User Assigned Identity for backup"
}

output "az_account_restore" {
  value       = azurerm_user_assigned_identity.mongo_restore_identity.client_id
  description = "Azure User Assigned Identity for restore"
}

output "root_password" {
  value       = var.mongodb_custom_credentials_enabled ? null : nonsensitive(random_password.mongodb_root_password[0].result)
  description = "Root user's password of MongoDB"
}

output "metric_exporter_pasword" {
  value       = var.mongodb_custom_credentials_enabled ? null : nonsensitive(random_password.mongodb_exporter_password[0].result)
  description = "mongodb_exporter user's password of MongoDB"
}
