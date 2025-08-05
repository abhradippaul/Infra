# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 21.0"

#   name               = var.eks_name
#   kubernetes_version = "1.33"

#   #   addons = {
#   #     coredns                = {}
#   #     eks-pod-identity-agent = {
#   #       before_compute = true
#   #     }
#   #     kube-proxy             = {}
#   #     vpc-cni                = {
#   #       before_compute = true
#   #     }
#   #   }

#   # Optional
#   endpoint_public_access = true

#   # Optional: Adds the current caller identity as an administrator via cluster access entry
#   enable_cluster_creator_admin_permissions = true

#   vpc_id                   = module.vpc.default_vpc_id
#   subnet_ids               = module.vpc.public_subnets[*].id
# #   control_plane_subnet_ids = module.vpc.public_subnets[*].id

#   # EKS Managed Node Group(s)
#   eks_managed_node_groups = {
#     node_group = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       ami_type       = "AL2023_x86_64_STANDARD"
#       instance_types = [var.eks_node]

#       min_size     = 1
#       max_size     = 2
#       desired_size = 1
#     }
#   }

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#     Name = "${var.eks_name}-${vpc}"
#   }
# }
