data "aws_eks_cluster" "stackspot_cluster" {
  name = var.cluster_name
}

data "aws_caller_identity" "getidentity" {}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}