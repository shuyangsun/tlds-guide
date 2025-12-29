# Path: infra/tooling/cicd/github_workflows/main.tf

module "gh_workflows_staging" {
  source      = "../../../modules/tooling/github_workflows"
  environment = "staging"
}

module "gh_workflows_prod" {
  source      = "../../../modules/tooling/github_workflows"
  environment = "prod"
}
