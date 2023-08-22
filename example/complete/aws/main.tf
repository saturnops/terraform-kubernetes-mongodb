locals {
  name        = "mongo"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  store_password_to_secret_manager   = true
  mongodb_custom_credentials_enabled = true
  mongodb_custom_credentials_config = {
    root_user                = "root"
    root_password            = "NCPFUKEMd7rrWuvMAa73"
    metric_exporter_user     = "mongodb_exporter"
    metric_exporter_password = "nvAHhm1uGQNYWVw6ZyAH"
  }
}
module "aws" {
  source                             = "../../../provider/aws"
  environment                        = local.environment
  name                               = local.name
  store_password_to_secret_manager   = local.store_password_to_secret_manager
  cluster_name                       = "dev-cluster"
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
}

module "mongodb" {
  source = "../../../" #"saturnops/mongodb/kubernetes"
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
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
  root_password                      = local.mongodb_custom_credentials_enabled ? "" : module.aws.root_password
  metric_exporter_pasword            = local.mongodb_custom_credentials_enabled ? "" : module.aws.metric_exporter_pasword
  bucket_provider_type               = "s3"
  mongodb_backup_enabled             = true
  iam_role_arn_backup                = module.aws.iam_role_arn_backup
  mongodb_backup_config = {
    s3_bucket_uri        = "s3://bucket_name"
    s3_bucket_region     = "bucket_region"
    cron_for_full_backup = "* * * * *"
  }
  mongodb_restore_enabled = true
  iam_role_arn_restore    = module.aws.iam_role_arn_restore
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
