
variable "recovery_window_aws_secret" {
  type        = number
  default     = 0
  description = "Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery."
}

variable "name" {
  description = "Name identifier for module to be added as suffix to resources"
  type        = string
  default     = "test"
}

variable "environment" {
  description = "Environment in which the infrastructure is being deployed (e.g., production, staging, development)"
  type        = string
  default     = "test"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the EKS cluster to deploy the Mongodb application on."
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

variable "store_password_to_secret_manager" {
  type        = bool
  default     = false
  description = "Specifies whether to store the credentials in GCP secret manager."
}
