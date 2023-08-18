locals {
  name        = "mongo"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  store_password_to_secret_manager = true
}

module "mongodb" {
  source       = "saturnops/mongodb/kubernetes"
  cluster_name = "dev-cluster"
  project_id   = "" #for gcp
  mongodb_config = {
    name                             = local.name
    values_yaml                      = file("./helm/values.yaml")
    environment                      = local.environment
    volume_size                      = "10Gi"
    architecture                     = "replicaset"
    replica_count                    = 2
    storage_class_name               = "gp3"
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mongodb_custom_credentials_enabled = true
  mongodb_custom_credentials_config = {
    root_user                = "root"
    root_password            = "NCPFUKEMd7rrWuvMAa73"
    metric_exporter_user     = "mongodb_exporter"
    metric_exporter_password = "nvAHhm1uGQNYWVw6ZyAH"
  }
  bucket_provider_type   = "gcs"
  mongodb_backup_enabled = true
  mongodb_backup_config = {
    bucket_uri           = "gs://mongo-backup-skaf"
    s3_bucket_region     = ""
    cron_for_full_backup = "* * * * *"
  }
  mongodb_restore_enabled = true
  mongodb_restore_config = {
    bucket_uri       = "gs://mongo-backup-skaf/mongodumpfull_20230710_132301.gz"
    s3_bucket_region = ""
    file_name        = "mongodumpfull_20230710_132301.gz"

  }
  mongodb_exporter_enabled = true
}
