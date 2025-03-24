resource "aws_eks_cluster" "app_eks_cluster" {
  name     = "app-eks-cluster"
  role_arn = data.aws_iam_role.lab_role.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = ["${data.aws_subnet.private_subnet_1.id}", "${data.aws_subnet.private_subnet_2.id}", "${data.aws_subnet.public_subnet_1.id}", "${data.aws_subnet.public_subnet_2.id}"]
    security_group_ids      = ["${aws_security_group.eks_cluster.id}", "${aws_security_group.eks_worker.id}"]
  }
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }


}

resource "aws_eks_access_entry" "app_eks_cluster_entry" {
  cluster_name  = aws_eks_cluster.app_eks_cluster.name
  principal_arn = var.voclabs_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "app_eks_cluster_association" {
  cluster_name  = aws_eks_cluster.app_eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.voclabs_role_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_node_group" "my_eks_node_group" {
  cluster_name    = aws_eks_cluster.app_eks_cluster.name
  node_group_name = "app-eks-node-group"
  node_role_arn   = data.aws_iam_role.lab_role.arn
  subnet_ids      = ["${data.aws_subnet.private_subnet_1.id}", "${data.aws_subnet.private_subnet_2.id}"]
  capacity_type   = "ON_DEMAND"
  disk_size       = 50
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }


}
