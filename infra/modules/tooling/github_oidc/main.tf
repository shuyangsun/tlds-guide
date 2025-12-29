# Path: infra/modules/tooling/github_oidc/main.tf

resource "aws_iam_openid_connect_provider" "github" {
  url             = local.gh_oidc_url
  client_id_list  = [local.gh_oidc_client_id]
  thumbprint_list = [local.gh_oidc_thumbprint]
}
