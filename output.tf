output "mongodb_endpoints" {
  description = "MongoDB_Info"
  value = {
    mongoport        = "27017",
    mongodb_endpoint = "mongodb-headless.${var.namespace}.svc.cluster.local"
  }
}

output "mongodb_credential" {
  description = "MongoDB_Info"
  value = var.mongodb_config.store_password_to_secret_manager ? null : {
    root_user                = "root",
    root_password            = nonsensitive(random_password.mongodb_root_password.result),
    metric_exporter_user     = "mongodb_exporter",
    metric_exporter_password = nonsensitive(random_password.mongodb_exporter_password.result)
  }
}
