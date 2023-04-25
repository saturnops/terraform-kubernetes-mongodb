output "mongodb" {
  description = "MongoDB_Info"
  value = {
    mongoport        = "27017",
    mongodb_endpoint = "mongodb-headless.${var.namespace}.svc.cluster.local"
  }
}
