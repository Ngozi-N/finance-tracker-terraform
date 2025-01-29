resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }
}

resource "aws_iam_role" "eks" {
  name = "eks-cluster-role"
  assume_role_policy = file("${path.module}/iam_policies/eks_assume_role.json")
}

