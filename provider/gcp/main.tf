resource "google_secret_manager_secret" "mongo-secret" {
  count     = var.mongodb_config.store_password_to_secret_manager ? 1 : 0
  project   = var.project_id
  secret_id = format("%s-%s-%s", var.mongodb_config.environment, var.mongodb_config.name, "mongo")

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mongo-secret" {
  count  = var.mongodb_config.store_password_to_secret_manager ? 1 : 0
  secret = google_secret_manager_secret.mongo-secret[0].id
  secret_data = var.mongodb_custom_credentials_enabled ? jsonencode(
    {
      "root_user" : "${var.mongodb_custom_credentials_config.root_user}",
      "root_password" : "${var.mongodb_custom_credentials_config.root_password}",
      "metric_exporter_user" : "${var.mongodb_custom_credentials_config.metric_exporter_user}",
      "metric_exporter_password" : "${var.mongodb_custom_credentials_config.metric_exporter_password}"
    }) : jsonencode(
    {
      "root_user" : "root",
      "root_password" : "${random_password.mongodb_root_password[0].result}",
      "metric_exporter_user" : "mongodb_exporter",
      "metric_exporter_password" : "${random_password.mongodb_exporter_password[0].result}"
  })
}

resource "google_service_account" "mongo_backup" {
  project      = var.project_id
  account_id   = format("%s-%s", var.environment, var.gcp_gsa_backup_name)
  display_name = "Service Account for mongo Backup"
}

resource "google_project_iam_member" "secretadmin_backup" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.mongo_backup.email}"
}

resource "google_project_iam_member" "service_account_token_creator_backup" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.mongo_backup.email}"
}

resource "google_service_account_iam_member" "pod_identity_backup" {
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[mongodb/${var.gcp_ksa_backup_name}]"
  service_account_id = google_service_account.mongo_backup.name
}

resource "google_service_account" "mongo_restore" {
  project      = var.project_id
  account_id   = format("%s-%s", var.environment, var.gcp_gsa_restore_name)
  display_name = "Service Account for mongo restore"
}

resource "google_project_iam_member" "secretadmin_restore" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.mongo_restore.email}"
}

resource "google_project_iam_member" "service_account_token_creator_restore" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.mongo_restore.email}"
}

resource "google_service_account_iam_member" "pod_identity_restore" {
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[mongodb/${var.gcp_ksa_restore_name}]"
  service_account_id = google_service_account.mongo_restore.name
}

output "service_account_backup" {
  value       = google_service_account.mongo_backup.email
  description = "Google Cloud Service Account name for backup"
}

output "service_account_restore" {
  value       = google_service_account.mongo_restore.email
  description = "Google Cloud Service Account name for restore"
}
