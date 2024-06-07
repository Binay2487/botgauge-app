provider "aws" {
  region = "us-west-2"  
}

# Define the VPC where the EKS cluster will be deployed (if not already created)
resource "aws_vpc" "eks_cluster_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Define the IAM role for the EKS service
module "eks_role" {
  source  = "terraform-aws-modules/iam/aws//modules/eks_service_role"
  version = "3.0.0"
  create_eks_service_account = true
}

# Define the EKS cluster
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.10.0"
  
  cluster_name      = "my-cluster"
  cluster_version   = "1.21"
  subnets           = [aws_subnet.my_subnet.id]  
  vpc_id            = aws_vpc.eks_cluster_vpc.id
  enable_irsa       = true
  tags = {
    Environment = "Production"
  }

  # Add-on configuration (optional)
  # addons_config = [...]
  
  # Worker node configuration (optional)
  # worker_groups = [...]
}

# Define a subnet (if not already created) for the EKS worker nodes
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}
