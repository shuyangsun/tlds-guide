# Path: infra/tooling/github_repo_protection/main.tf

module "github_repo_protection" {
  source = "../../modules/tooling/github_repo_protection"

  repository_name = "tlds-guide"

  # Set to 1 if you want to require at least 1 approval (self-approval won't work)
  # Set to 0 if you're the only contributor and want to self-merge
  # TODO: Re-enable main branch push protection when ready
  # require_approving_reviews = 0
}
