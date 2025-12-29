# Path: infra/tooling/cicd/github_workflows/main.tf

module "gh_workflows" {
  source      = "../../../modules/tooling/github_workflows"
  environment = "staging"
}
