locals {
  region      = "us-east-2"
  name        = "skaf"
  environment = "prod"

}

module "mongodb" {
  source                   = "../../"
  mongodb_backup_enabled   = true
  mongodb_exporter_enabled = true
  cluster_name             = ""
  mongodb_config = {
    name               = local.name
    environment        = local.environment
    volume_size        = "10Gi"
    architecture       = "replicaset"
    replica_count      = 2
    storage_class_name = "gp2"
    values_yaml        = file("./helm/values.yaml")
  }
  mongodb_backup_config = {
    s3_bucket_uri         = ""
    aws_access_key_id     = ""
    aws_secret_access_key = ""
    s3_bucket_region      = local.region
    cron_for_full_backup  = ""
  }
}
