# Path: infra/tooling/github_repo_protection/variables.tf

variable "github_token" {
  description = "GitHub Personal Access Token with repo and admin:org permissions"
  type        = string
  sensitive   = true
}
