# Path: infra/modules/tooling/github_workflows/locals.tf

locals {
  gh_oidc_url        = "https://token.actions.githubusercontent.com"
  gh_oidc_client_id  = "sts.amazonaws.com"
  gh_oidc_thumbprint = "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  gh_repo_branch     = "shuyangsun/tlds-guide:ref:refs/heads/main"

  iam_policy_doc_name    = "GitHubActions${var.environment == "prod" ? "Staging" : "Prod"}AssumeRole"
  iam_policy_name        = "terraform-state-access-${var.environment}"
  iam_role_name          = "github-actions-terraform-${var.environment}"
  state_s3_bucket        = "shuyang-tfstate-${var.environment}-us-east-1"
  state_s3_bucket_shared = "shuyang-tfstate-${var.environment}-us-east-1"
}
