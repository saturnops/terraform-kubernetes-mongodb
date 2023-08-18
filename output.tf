output "mongodb_endpoints" {
  description = "MongoDB endpoints in the Kubernetes cluster."
  value = {
    mongoport        = "27017",
    mongodb_endpoint = "mongodb-headless.${var.namespace}.svc.cluster.local"
  }
}

output "mongodb_credential" {
  description = "MongoDB credentials used for accessing the MongoDB database."
  value = var.mongodb_config.store_password_to_secret_manager ? null : {
    root_user                = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_user : "root",
    root_password            = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : nonsensitive(random_password.mongodb_root_password[0].result),
    metric_exporter_user     = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.metric_exporter_user : "mongodb_exporter",
    metric_exporter_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.metric_exporter_password : nonsensitive(random_password.mongodb_exporter_password[0].result)
  }
}
