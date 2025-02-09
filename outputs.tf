output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "rds_endpoint" {
  value = aws_db_instance.finance_tracker_db.endpoint
}

output "rds_database_url" {
  value = "postgresql://${var.rds_username}:${var.rds_password}@${aws_db_instance.finance_tracker_db.endpoint}:5432/${var.rds_database}"
  sensitive = true
}

output "s3_bucket_name" {
  value = aws_s3_bucket.finance_tracker_uploads.bucket  
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "node_group_name" {
  value = aws_eks_node_group.finance_tracker_nodes.node_group_name
}
