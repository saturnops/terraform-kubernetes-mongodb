locals {
  region      = "us-east-2"
  name        = "dev"
  environment = "skaf"

}

module "mongodb" {
  source       = "../../"
  cluster_name = "dev-skaf"
  mongodb_config = {
    name               = local.name
    values_yaml        = file("./helm/values.yaml")
    environment        = local.environment
    volume_size        = "10Gi"
    architecture       = "replicaset"
    replica_count      = 2
    storage_class_name = "gp2"
  }
  mongodb_backup_config = {
    s3_bucket_uri        = "s3://mymongo"
    s3_bucket_region     = local.region
    cron_for_full_backup = "*/2 * * * *"
  }
  mongodb_backup_enabled   = true
  mongodb_exporter_enabled = false
}
