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
  description = "Mongodb configurations"
}

variable "chart_version" {
  type        = string
  default     = "13.1.5"
  description = "Enter chart version of application"
}

variable "app_version" {
  type        = string
  default     = "5.0.8-debian-10-r9"
  description = "Enter app version of application"
}

variable "namespace" {
  type        = string
  default     = "mongodb"
  description = "Enter namespace name"
}

variable "mongodb_backup_enabled" {
  type        = bool
  default     = false
  description = "Set true to enable mongodb backups"
}

variable "mongodb_backup_config" {
  type = any
  default = {
    s3_bucket_uri        = ""
    s3_bucket_region     = "us-east-2"
    cron_for_full_backup = "*/5 * * * *"
  }
  description = "Mongodb Backup configurations"
}

variable "mongodb_exporter_enabled" {
  type        = bool
  default     = false
  description = "Set true to deploy mongodb exporters to get metrics in grafana"
}

variable "mongodb_exporter_config" {
  type = any
  default = {
    version = "2.9.0"
  }
  description = "Mongodb exporter configuration"
}

variable "recovery_window_aws_secret" {
  default     = 0
  type        = number
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = ""
}

variable "create_namespace" {
  type        = string
  description = "Set it to true to create given namespace"
  default     = true
}
