terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=5.16.0"
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
  env = include.env.locals.env

  enable_nat_gateway = true
  name               = include.env.locals.project_name
  azs                = ["eu-west-1a", "eu-west-1b"]
  cidr               = "10.122.0.0/16"
  public_subnets     = ["10.122.1.0/24", "10.122.2.0/24"]
  private_subnets    = ["10.122.3.0/24", "10.122.4.0/24"]
  intra_subnets      = ["10.122.5.0/24", "10.122.6.0/24"]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
}