resource "aws_iam_role" "eks_nodes" {
  name = "eks-nodes-role"
  assume_role_policy = file("${path.module}/iam_policies/eks_nodes_assume_role.json")
}

resource "aws_iam_policy_attachment" "eks_node_policy" {
  name       = "eks-node-policy"
  roles      = [aws_iam_role.eks_nodes.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
