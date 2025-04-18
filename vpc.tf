provider "aws" {
  region = "us-west-1"
}

variable "vpc_cidr_block" {}
variable "private_subnet_cidr_block" {}
variable "public_subnet_cidr_block" {}

data "aws_availability_zones" "azs" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  ## Pass in the VPC attribute that we need to create VPC for EKS Cluster

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block

  azs = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet_cidr_block
  public_subnets = var.public_subnet_cidr_block 

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
  "kubernetes.io/cluster/myapp-eks-cluster" = "shared" # This will be a cluster name
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

}