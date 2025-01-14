terraform {
  source = "git::https://github.com/mrtmrcbr/terraform-modules.git//ecr?ref=v1.0"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name = "myapp"
}