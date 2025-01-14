terraform {
  source = "git::git@github.com:mrtmrcbr/terraform-modules.git//cloudfront?ref=v1.1"
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
  bucket_name = format("mrtmrcbr-cloudfront-%s", lower(include.env.locals.env))
  environment = include.env.locals.env
}