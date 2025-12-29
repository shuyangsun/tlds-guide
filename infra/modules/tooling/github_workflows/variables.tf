# Path: infra/modules/tooling/github_workflows/variables.tf

variable "environment" {
  description = "Deployment environment, possible values are \"prod\" and \"staging\""
  type        = string

  validation {
    condition     = contains(["prod", "staging"], var.environment)
    error_message = "Environment must be either \"prod\" or \"staging\"."
  }
}
