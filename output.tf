output "mongodb" {
  description = "MongoDB_Info"
  value = {
    mongoport        = module.mongodb.mongodb_port,
    mongodb_endpoint = module.mongodb.mongodb_endpoint
  }
}
