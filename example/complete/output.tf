output "mongodb_endpoints" {
  value       = module.mongodb.mongodb_endpoints
  description = "Mongodb_Info"
}

output "mongodb_credential" {
  value       = local.store_password_to_secret_manager ? null : module.mongodb.mongodb_credential
  description = "Mongodb_Info"
}
