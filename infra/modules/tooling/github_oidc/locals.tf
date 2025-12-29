# Path: infra/modules/tooling/github_oidc/locals.tf

locals {
  gh_oidc_url        = "https://token.actions.githubusercontent.com"
  gh_oidc_client_id  = "sts.amazonaws.com"
  gh_oidc_thumbprint = "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
}
