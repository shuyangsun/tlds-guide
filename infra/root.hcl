generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    region = "${local.env_vars.locals.state_aws_region}"
    bucket = "${local.env_vars.locals.state_bucket}"
    key    = "tlds_guide/{path_relative_to_include()}/terraform.tfstate"

    use_lockfile = true
    encrypt      = true
  }
}
EOF
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}
