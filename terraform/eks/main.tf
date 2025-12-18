module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"


  cluster_name    = "django-eks"
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

#  enable_cluster_creator_admin_permissions = true


  enable_irsa = true

  eks_managed_node_groups = {
    private_nodes = {
      desired_size = 2
      min_size     = 1
      max_size     = 3

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }


  tags = {
    Project = "django-zero-trust"
  }
}
