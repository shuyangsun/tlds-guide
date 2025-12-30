# Path: infra/modules/tooling/github_oidc/locals.tf

locals {
  gh_oidc_url        = "https://token.actions.githubusercontent.com"
  gh_oidc_client_id  = "sts.amazonaws.com"
  gh_oidc_thumbprint = "1c58a3a8518e8759bf075b76b750d4f2df264fcd"

  # GitHub repository identifiers for OIDC trust policies
  gh_repo              = "shuyangsun/tlds-guide"
  gh_repo_branch_main  = "${local.gh_repo}:ref:refs/heads/main"
  gh_repo_tag_releases = "${local.gh_repo}:ref:refs/tags/v*" # Matches release tags (v1.0.0, v2.1.3, etc.)

  state_s3_bucket_staging = "shuyang-tfstate-staging-us-east-1"
  state_s3_bucket_prod    = "shuyang-tfstate-prod-us-east-1"
  state_s3_bucket_shared  = "shuyang-tfstate-shared-services-us-east-1"
}
