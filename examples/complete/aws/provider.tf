provider "aws" {
  region = local.region
  default_tags {
    tags = local.additional_tags
  }
}

data "aws_eks_cluster" "cluster" {
  name = "dev-skaf"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "dev-skaf"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
