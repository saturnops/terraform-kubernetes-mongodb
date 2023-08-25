output "mongodb_endpoints" {
  value       = module.mongodb.mongodb_endpoints
  description = "MongoDB endpoints in the Kubernetes cluster."
}

output "mongodb_credential" {
  value       = local.store_password_to_secret_manager ? null : module.mongodb.mongodb_credential
  description = "MongoDB credentials used for accessing the MongoDB database."
}
