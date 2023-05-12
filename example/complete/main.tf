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
  source       = "https://github.com/sq-ia/terraform-kubernetes-mongodb.git"
  cluster_name = "dev-cluster"
  mongodb_config = {
    name               = local.name
    values_yaml        = file("./helm/values.yaml")
    environment        = local.environment
    volume_size        = "10Gi"
    architecture       = "replicaset"
    replica_count      = 2
    storage_class_name = "gp2"
  }
  mongodb_backup_enabled = true
  mongodb_backup_config = {
    s3_bucket_uri        = "s3://mymongo"
    s3_bucket_region     = local.region
    cron_for_full_backup = "*/2 * * * *"
  }
  mongodb_restore_enabled = true
  mongodb_restore_config = {
    s3_bucket_uri              = "s3://mymongo/mongodumpfull_20230424_112501.gz"
    s3_bucket_region           = "us-east-2"
    full_restore_enable        = true
    file_name_full             = "mongodumpfull_20230424_112501.gz"
    incremental_restore_enable = false
    file_name_incremental      = ""
  }
  mongodb_exporter_enabled = true
}
