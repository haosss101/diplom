provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "shpakovsky-bucket"
    key    = "dev/dev.tfstate"
    region = "us-east-1"
    dynamodb_table = "lockstate-shpakovsky"
  }
}

locals {
  name = "${var.name}"
  instance = "${var.instance}"
  cidr = "${var.cidr}"  
  azs = ["${var.azs1}", "${var.azs2}"]
  public_subnets = ["${var.pub1}", "${var.pub2}"]
  private_subnets = ["${var.priv1}", "${var.priv2}"]
  intra_subnets = ["${var.int1}", "${var.int2}"]
  repository_name = "${var.repository_name}"
  arn = "${var.arn}"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.intra_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"
  
  
  create_kms_key = false 
  enable_kms_key_rotation = false

  cluster_name                   = local.name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = [local.instance]   
    disk_size = 8
    use_custom_launch_template = false    

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    shpakovsky_node = {
      min_size     = 2
      max_size     = 4
      desired_size = 2      
      
      instance_types = [local.instance]
      capacity_type  = "ON_DEMAND"
      
      tags = {
        ExtraTag = local.name
        Name = "shpakovsky_node"
      }
    }
  }
}


module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = local.repository_name

  repository_read_write_access_arns = [local.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    ExtraTag = local.name
  }
}