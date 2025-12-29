include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "github_oidc" {
  config_path = "../../../global/tooling/github_oidc"
}

inputs = {
  github_oidc_provider_arn = dependency.github_oidc.outputs.oidc_provider_arn
}
