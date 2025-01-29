output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "rds_endpoint" {
  value = aws_db_instance.finance_tracker_db.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.finance_tracker_uploads.bucket  
}

