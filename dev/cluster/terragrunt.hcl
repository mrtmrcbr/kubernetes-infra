terraform {
  source = "tfr:///terraform-aws-modules/eks/aws?version=20.31.6"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  version = "20.31.6"

  cluster_name                   = include.env.locals.project_name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = dependency.network.outputs.vpc_id
  subnet_ids               = dependency.network.outputs.private_subnets
  control_plane_subnet_ids = dependency.network.outputs.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m5.large"]

    attach_cluster_primary_security_group = true
  }

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    myapp-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "helloworld"
      }
    }
  }
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    vpc_id          = "temp-id"
    private_subnets = ["temp"]
    intra_subnets   = ["temp"]
  }
}