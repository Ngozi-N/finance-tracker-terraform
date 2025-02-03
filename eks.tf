# Create EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids         = [aws_subnet.private[0].id, aws_subnet.private[1].id]
    security_group_ids = [aws_security_group.eks.id]  # Attach security group
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# Create EKS Node Group (Worker Nodes)
resource "aws_eks_node_group" "finance_tracker_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "finance-tracker-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn  # Uses IAM role from iam.tf
  subnet_ids      = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key = var.ssh_key_name  # Ensure an SSH key is provided
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_iam_role_policy_attachment.eks_worker_node,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only
  ]
<<<<<<< HEAD
}
=======
}
>>>>>>> e0c2728 (Commit files)
