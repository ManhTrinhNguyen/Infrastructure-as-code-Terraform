module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.32"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    dev = {
      ami_type       = "AL2023_x86_64_STANDARD"  # Amazon Linux 2023 (x86_64) Standard
      instance_types = ["t3.medium"]

      min_size = 2
      max_size = 4
      desired_size = 2
    }
  }

  tags = {
    environment = "dev"
    application = "myapp"
  }
}