data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_subscription" "primary" {}

# resource "azurerm_role_definition" "blob_storage_access" {
#   name        = "BlobStorageAccess"
#   description = "Role definition for accessing Azure Blob Storage"
#   scope       = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"

#   permissions {
#     actions = [
#       "Microsoft.Storage/storageAccounts/blobServices/containers/read",
#       "Microsoft.Storage/storageAccounts/blobServices/containers/write",
#       "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
#     ]

#     not_actions = []
#   }

#   assignable_scopes = [
#     "/subscriptions/${data.azurerm_subscription.current.subscription_id}",
#   ]
# }

# resource "azurerm_role_assignment" "blob_storage_access_assignment" {
#   principal_id   = azurerm_user_assigned_identity.mongo_backup_identity.principal_id
#   role_definition_name = azurerm_role_definition.blob_storage_access.name
#   scope          = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
# }

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

resource "azurerm_key_vault" "mongo-secret" {
  count                       = var.store_password_to_secret_manager ? 1 : 0
  name                        = format("%s-%s-%s", var.environment, var.name, "mongodb")
  resource_group_name         = var.resource_group_name
  location                    = var.resource_group_location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get",
      "List",
    ]
    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
      "Purge",
    ]
  }
}

resource "azurerm_key_vault_secret" "mongo-secret" {
  depends_on = [azurerm_key_vault.mongo-secret[0]]
  name       = format("%s-%s-%s", var.environment, var.name, "secret")
  value = var.mongodb_custom_credentials_enabled ? jsonencode(
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
  content_type = "application/json"
  key_vault_id = azurerm_key_vault.mongo-secret[0].id
}

# Create a service principal for mongo backup
resource "azurerm_user_assigned_identity" "mongo_backup_identity" {
  name                = format("%s-%s-%s", var.environment, var.name, "mongo_backup_identity")
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

# Grant the storage blob contributor role to the backup service principal
resource "azurerm_role_assignment" "secretadmin_backup" {
  principal_id         = azurerm_user_assigned_identity.mongo_backup_identity.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/test-skaf-tfstate-rg/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
}

# Grant the "Managed Identity Token Creator" role to the backup service principal
resource "azurerm_role_assignment" "service_account_token_creator_backup" {
  principal_id         = azurerm_user_assigned_identity.mongo_backup_identity.principal_id
  role_definition_name = "Role Based Access Control Administrator (Preview)"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/test-skaf-tfstate-rg"
}

# Create a service principal for mongo restore
resource "azurerm_user_assigned_identity" "mongo_restore_identity" {
  name                = format("%s-%s-%s", var.environment, var.name, "mongo_restore_identity")
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

# Grant the storage blob contributor role to the restore service principal
resource "azurerm_role_assignment" "secretadmin_restore" {
  principal_id         = azurerm_user_assigned_identity.mongo_restore_identity.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/test-skaf-tfstate-rg/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
}

# Grant the "Managed Identity Token Creator" role to the restore service principal
resource "azurerm_role_assignment" "service_account_token_creator_restore" {
  principal_id         = azurerm_user_assigned_identity.mongo_restore_identity.principal_id
  role_definition_name = "Role Based Access Control Administrator (Preview)"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/test-skaf-tfstate-rg"
}

# Configure workload identity for mongo backup
resource "azurerm_user_assigned_identity" "pod_identity_backup" {
  name                = format("%s-%s-%s", var.environment, var.name, "pod_identity_backup")
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_role_assignment" "pod_identity_assignment_backup" {
  principal_id         = azurerm_user_assigned_identity.pod_identity_backup.principal_id
  role_definition_name = "Managed Identity Operator"
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}"
}
