output "mongodb_port" {
  value       = "27017"
  description = "Mongodb Port"
}

output "mongodb_endpoint" {
  value = "mongodb-headless.${var.namespace}.svc.cluster.local"
}
