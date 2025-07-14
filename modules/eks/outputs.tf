output "cluster_endpoint" {
  description = "value of the EKS cluster endpoint"
  value = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "name of the EKS cluster"
  value = aws_eks_cluster.main.name
}