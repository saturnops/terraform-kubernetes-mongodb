output "mongodb_configuration" {
  value       = module.mongodb.mongodb
  description = "Mongodb_Info"
}

output "mongodb_endpoint" {
  value = module.mongodb.mongodb_endpoint
}
