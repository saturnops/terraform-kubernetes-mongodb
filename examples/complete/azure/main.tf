locals {
  name        = "mongo"
  region      = "eastus"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  create_namespace                   = false
  namespace                          = ""
  store_password_to_secret_manager   = true
  mongodb_custom_credentials_enabled = true
  mongodb_custom_credentials_config = {
    root_user                = "root"
    root_password            = "NCPFUKEMd7rrWuvMAa73"
    metric_exporter_user     = "mongodb_exporter"
    metric_exporter_password = "nvAHhm1uGQNYWVw6ZyAH"
  }

  azure_storage_account_name = ""
  azure_container_name       = ""
}

module "azure" {
  source                             = "saturnops/mongodb/kubernetes//modules/resources/azure"
  resource_group_name                = ""
  resource_group_location            = ""
  name                               = local.name
  environment                        = local.environment
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
  store_password_to_secret_manager   = local.store_password_to_secret_manager
  storage_account_name               = local.azure_storage_account_name
}

module "mongodb" {
  source                  = "saturnops/mongodb/kubernetes"
  cluster_name            = ""
  namespace               = local.namespace
  create_namespace        = local.create_namespace
  resource_group_name     = ""
  resource_group_location = ""
  mongodb_config = {
    name                             = local.name
    namespace                        = local.namespace
    values_yaml                      = file("./helm/values.yaml")
    volume_size                      = "10Gi"
    architecture                     = "replicaset"
    replica_count                    = 1
    environment                      = local.environment
    custom_databases                 = "['db1', 'db2']"
    custom_databases_usernames       = "['admin', 'admin']"
    custom_databases_passwords       = "['pass1', 'pass2']"
    storage_class_name               = "infra-service-sc"
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
  root_password                      = local.mongodb_custom_credentials_enabled ? "" : module.azure.root_password
  metric_exporter_password           = local.mongodb_custom_credentials_enabled ? "" : module.azure.metric_exporter_pasword
  bucket_provider_type               = "azure"
  mongodb_backup_enabled             = false
  mongodb_backup_config = {
    bucket_uri                 = "https://${local.azure_storage_account_name}.blob.core.windows.net/${local.azure_container_name}"
    azure_storage_account_name = local.azure_storage_account_name
    azure_container_name       = local.azure_container_name
    cron_for_full_backup       = "* * 1 * *"
  }
  mongodb_restore_enabled = false
  mongodb_restore_config = {
    bucket_uri                 = "https://${local.azure_storage_account_name}.blob.core.windows.net/${local.azure_container_name}"
    azure_storage_account_name = local.azure_storage_account_name
    azure_container_name       = local.azure_container_name
    file_name                  = "mongodumpfull_20230710_132301.gz"
  }
  mongodb_exporter_enabled = true
}
