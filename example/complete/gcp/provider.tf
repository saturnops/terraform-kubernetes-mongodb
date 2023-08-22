data "google_client_config" "default" {}

data "google_container_cluster" "primary" {
  name     = "skaf-dev-gke-cluster"
  location = "asia-south1"
  project  = "fresh-sanctuary-389006"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

provider "google" {
  region  = "asia-south1"
  project = "fresh-sanctuary-389006"
}

provider "aws" {
  alias      = "aws"
  access_key = null
  secret_key = null
}
