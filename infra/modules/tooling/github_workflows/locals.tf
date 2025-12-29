# Path: infra/modules/tooling/github_workflows/locals.tf

locals {
  gh_repo_branch = "shuyangsun/tlds-guide:ref:refs/heads/main"

  iam_policy_doc_name    = "GitHubActions${var.environment == "prod" ? "Prod" : "Staging"}AssumeRole"
  iam_policy_name        = "terraform-state-access-${var.environment}"
  iam_role_name          = "github-actions-terraform-${var.environment}"
  state_s3_bucket        = "shuyang-tfstate-${var.environment}-us-east-1"
  state_s3_bucket_prod   = "shuyang-tfstate-prod-us-east-1"
  state_s3_bucket_shared = "shuyang-tfstate-shared-services-us-east-1"
}
