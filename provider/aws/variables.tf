
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

variable "root_password" {
  description = "Root user password for MySQL"
  type        = string
}

variable "metric_exporter_pasword" {
  description = "Password for the mongo_exporter user"
  type        = string
}

variable "mongodb_config" {
  type = any
  default = {
    name                             = ""
    environment                      = ""
    volume_size                      = ""
    architecture                     = ""
    replica_count                    = 2
    values_yaml                      = ""
    storage_class_name               = ""
    store_password_to_secret_manager = true
  }
  description = "Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values."
}

variable "namespace" {
  type        = string
  default     = "mongodb"
  description = "Name of the Kubernetes namespace where the Mongodb deployment will be deployed."
}

variable "mongodb_custom_credentials_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable custom credentials for MongoDB database."
}

variable "mongodb_custom_credentials_config" {
  type = any
  default = {
    root_user                = ""
    root_password            = ""
    metric_exporter_user     = ""
    metric_exporter_password = ""
  }
  description = "Specify the configuration settings for Mongodb to pass custom credentials during creation."
}
