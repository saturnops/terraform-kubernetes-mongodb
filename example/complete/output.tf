output "mongodb_port" {
  value       = "27017"
  description = "Mongodb Port"
}

output "mongodb_endpoint" {
  value = module.mongodb.mongodb_endpoint
}
