# Path: infra/modules/tooling/github_repo_protection/variables.tf

variable "repository_name" {
  description = "The name of the GitHub repository to protect"
  type        = string
}

# Note: For personal repositories, user/team restrictions are not supported.
# The following restrictions only work for organization repositories:
# - push_allowances
# - dismissal_restrictions
# - force_push_bypassers
# For personal repos, the owner has full control via enforce_admins setting.

# TODO: Re-enable main branch push protection when ready
# variable "require_approving_reviews" {
#   description = "Number of required approving reviews for PRs (0-6)"
#   type        = number
#   default     = 0

#   validation {
#     condition     = var.require_approving_reviews >= 0 && var.require_approving_reviews <= 6
#     error_message = "require_approving_reviews must be between 0 and 6"
#   }
# }
