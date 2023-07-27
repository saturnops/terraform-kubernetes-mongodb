resource "google_secret_manager_secret" "mongo-secret" {
  project   = var.project_id
  secret_id = format("%s-%s-%s", var.mongodb_config.environment, var.mongodb_config.name, "mongo")

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mongo-secret" {
  secret      = google_secret_manager_secret.mongo-secret.id
  secret_data = <<EOF
   {
    "root_user": "root",
    "root_password": "${var.root_password}",
    "metric_exporter_user": "mongodb_exporter",
    "metric_exporter_password": "${var.metric_exporter_pasword}"
   }
EOF
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
