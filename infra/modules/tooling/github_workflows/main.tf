# Path: infra/modules/tooling/github_workflows/main.tf

resource "aws_iam_openid_connect_provider" "github" {
  url             = local.gh_oidc_url
  client_id_list  = [local.gh_oidc_client_id]
  thumbprint_list = [local.gh_oidc_thumbprint]
}

data "aws_iam_policy_document" "github_actions_assume" {
  statement {
    sid     = local.iam_policy_doc_name
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.gh_repo_branch}"]
    }
  }
}

resource "aws_iam_role" "github_actions_terraform" {
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume.json
}

resource "aws_iam_policy" "terraform_state" {
  name = local.iam_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ManageStateBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.state_s3_bucket}",
          "arn:aws:s3:::${local.state_s3_bucket}/*",
          "arn:aws:s3:::${local.state_s3_bucket_shared}",
          "arn:aws:s3:::${local.state_s3_bucket_shared}/*"
        ]
      },
      {
        Sid    = "ReadProdStateBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.state_s3_bucket_prod}",
          "arn:aws:s3:::${local.state_s3_bucket_prod}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_terraform_state" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = aws_iam_policy.terraform_state.arn
}
