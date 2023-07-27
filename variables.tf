variable "mongodb_config" {
  type = any
  default = {
    name               = ""
    environment        = ""
    volume_size        = ""
    architecture       = ""
    replica_count      = 2
    values_yaml        = ""
    storage_class_name = ""
  }
  description = "Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values."
}

variable "chart_version" {
  type        = string
  default     = "13.1.5"
  description = "Version of the Mongodb chart that will be used to deploy Mongodb application."
}

variable "app_version" {
  type        = string
  default     = "5.0.8-debian-10-r9"
  description = "Version of the Mongodb application that will be deployed."
}

variable "namespace" {
  type        = string
  default     = "mongodb"
  description = "Name of the Kubernetes namespace where the Mongodb deployment will be deployed."
}

variable "mongodb_backup_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable backups for Mongodb database."
}

variable "mongodb_backup_config" {
  type = any
  default = {
    bucket_uri           = ""
    s3_bucket_region     = "us-east-2"
    cron_for_full_backup = "*/5 * * * *"
  }
  description = "Configuration options for Mongodb database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups."
}

variable "mongodb_exporter_enabled" {
  type        = bool
  default     = false
  description = "Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana."
}

variable "mongodb_exporter_config" {
  type = any
  default = {
    version = "2.9.0"
  }
  description = "Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana."
}

variable "recovery_window_aws_secret" {
  type        = number
  default     = 0
  description = "Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery."
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the EKS cluster to deploy the Mongodb application on."
}

variable "create_namespace" {
  type        = string
  default     = true
  description = "Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace."
}

variable "mongodb_restore_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable restoring dump to the Mongodb database."
}

variable "mongodb_restore_config" {
  type = any
  default = {
    bucket_uri       = "s3://mymongo/mongodumpfull_20230424_112501.gz"
    s3_bucket_region = "us-east-2"
    file_name        = ""
  }
  description = "Configuration options for restoring dump to the Mongodb database."
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = ""
}

variable "bucket_provider_type" {
  type        = string
  default     = "gcs"
  description = "Choose what type of provider you want (s3, gcs)"
}
