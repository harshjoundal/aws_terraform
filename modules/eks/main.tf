

resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
                Service = "eks.amazonaws.com"
            }
        }
    ]
    })
}

resource "aws_iam_policy_attachment" "cluster_policy" {
    name       = "${var.cluster_name}-cluster-policy-attachment"
    roles = [aws_iam_role.cluster.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" 
}

resource "aws_eks_cluster" "main" {
  name = var.cluster_name
  version = var.cluster_version
  role_arn = aws_iam_role.cluster.arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [ 
    aws_iam_policy_attachment.cluster_policy 
  ]
}

resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_policy_attachment" "node_policy" {
    name       = "${var.cluster_name}-node-policy-attachment"
    roles = [aws_iam_role.node.name]

    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ])
    policy_arn = each.value
}

resource "aws_eks_node_group" "main" {
    for_each = var.node_groups

    cluster_name = aws_eks_cluster.main.name
    node_group_name = each.key
    node_role_arn = aws_iam_role.node.arn
    subnet_ids = var.subnet_ids

    scaling_config {
        desired_size = each.value.scaling_config.desired_size
        max_size     = each.value.scaling_config.max_size
        min_size     = each.value.scaling_config.min_size
    }

    depends_on = [ 
        aws_iam_policy_attachment.node_policy
    ]
}