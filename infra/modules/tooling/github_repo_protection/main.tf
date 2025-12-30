# Path: infra/modules/tooling/github_repo_protection/main.tf

# =============================================================================
# GitHub Repository Branch Protection
# =============================================================================

# Protect the main branch using branch protection rules
# This is the primary protection mechanism for the main branch
# Note: Personal repositories cannot have user/team restrictions
#       (push_allowances, dismissal_restrictions, force_push_bypassers)
#       These only work for organization repositories.
# TODO: Re-enable main branch push protection when ready
# resource "github_branch_protection" "main" {
#   repository_id = var.repository_name
#
#   pattern          = "main"
#   enforce_admins   = true  # Rules apply to admins too
#   allows_deletions = false # Prevent branch deletion
#
#   # Require pull request reviews before merging
#   required_pull_request_reviews {
#     dismiss_stale_reviews           = true
#     require_code_owner_reviews      = true # Enforce CODEOWNERS file
#     required_approving_review_count = var.require_approving_reviews
#     # Note: restrict_dismissals and dismissal_restrictions not available for personal repos
#   }
#
#   # Note: restrict_pushes with push_allowances not available for personal repos
#   # For personal repos, enforce_admins=true ensures owner must also follow rules
#
#   # Require linear history (no merge commits from direct pushes)
#   required_linear_history = true
#
#   # Disable force pushes for everyone
#   # Note: force_push_bypassers not available for personal repos
#   allows_force_pushes = false
# }

# =============================================================================
# GitHub Repository Tag Protection (Rulesets)
# =============================================================================

# Protect all tags - only repository admins can create/modify/delete them
# For personal repositories, the owner has the admin role by default
resource "github_repository_ruleset" "tags" {
  name        = "protect-version-tags"
  repository  = var.repository_name
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  # Only repository admins can bypass (actor_id 5 = admin role)
  # For personal repos, only the owner has admin role
  bypass_actors {
    actor_id    = 5 # RepositoryRole: admin
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    # Restrict tag creation to bypass actors only
    creation = true
    # Restrict tag deletion to bypass actors only
    deletion = true
    # Restrict tag updates to bypass actors only
    update = true
  }
}
