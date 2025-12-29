# Path: infra/tooling/github_repo_protection/provider.tf

provider "github" {
  token = var.github_token
  owner = "shuyangsun"
}
