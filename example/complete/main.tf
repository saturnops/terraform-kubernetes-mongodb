locals {
  name        = "mongo"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "mongodb" {
  source       = "saturnops/mongodb/kubernetes"
  cluster_name = "dev-cluster"
  mongodb_config = {
    name               = local.name
    values_yaml        = file("./helm/values.yaml")
    environment        = local.environment
    volume_size        = "10Gi"
    architecture       = "replicaset"
    replica_count      = 2
    storage_class_name = "gp3"
  }
  mongodb_backup_enabled = true
  mongodb_backup_config = {
    s3_bucket_uri        = "s3://bucket_name"
    s3_bucket_region     = "bucket_region"
    cron_for_full_backup = "* * * * *"
  }
  mongodb_restore_enabled = true
  mongodb_restore_config = {
    s3_bucket_uri              = "s3://bucket_name/filename"
    s3_bucket_region           = "bucket_region"
    full_restore_enable        = true
    file_name_full             = "filename"
    incremental_restore_enable = false
    file_name_incremental      = ""
  }
  mongodb_exporter_enabled = true
}
