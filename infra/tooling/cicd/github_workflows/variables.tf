# Path: infra/tooling/cicd/github_workflows/variables.tf

variable "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
}
