locals {
  name        = "mongo"
  region      = "asia-south1"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  create_namespace                   = true
  namespace                          = "mongodb"
  store_password_to_secret_manager   = true
  mongodb_custom_credentials_enabled = true
  mongodb_custom_credentials_config = {
    root_user                = "root"
    root_password            = "NCPFUKEMd7rrWuvMAa73"
    metric_exporter_user     = "mongodb_exporter"
    metric_exporter_password = "nvAHhm1uGQNYWVw6ZyAH"
  }
}

module "gcp" {
  source                             = "saturnops/mongodb/kubernetes//modules/resources/gcp"
  project_id                         = "fresh-sanctuary-387476" #for gcp
  environment                        = local.environment
  name                               = local.name
  store_password_to_secret_manager   = local.store_password_to_secret_manager
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
}


module "mongodb" {
  source           = "saturnops/mongodb/kubernetes"
  namespace        = local.namespace
  create_namespace = local.create_namespace
  cluster_name     = "dev-gke-cluster"
  mongodb_config = {
    name                             = local.name
    namespace                        = local.namespace
    values_yaml                      = file("./helm/values.yaml")
    environment                      = local.environment
    volume_size                      = "10Gi"
    architecture                     = "replicaset"
    custom_databases                 = "['db1', 'db2']"
    custom_databases_usernames       = "['admin', 'admin']"
    custom_databases_passwords       = "['pass1', 'pass2']"
    replica_count                    = 2
    storage_class_name               = "standard"
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
  root_password                      = local.mongodb_custom_credentials_enabled ? "" : module.gcp.root_password
  metric_exporter_password           = local.mongodb_custom_credentials_enabled ? "" : module.gcp.metric_exporter_pasword
  bucket_provider_type               = "gcs"
  service_account_backup             = module.gcp.service_account_backup
  service_account_restore            = module.gcp.service_account_restore
  mongodb_backup_enabled             = true
  mongodb_backup_config = {
    bucket_uri           = "gs://mongo-backup-dev"
    s3_bucket_region     = ""
    cron_for_full_backup = "* * * * *"
  }
  mongodb_restore_enabled = true
  mongodb_restore_config = {
    bucket_uri       = "gs://mongo-backup-dev/mongodumpfull_20230710_132301.gz"
    s3_bucket_region = ""
    file_name        = "mongodumpfull_20230710_132301.gz"

  }
  mongodb_exporter_enabled = true
}
