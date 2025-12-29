# Path: infra/modules/tooling/github_oidc/main.tf

# =============================================================================
# GitHub OIDC Provider (one per AWS account)
# =============================================================================

resource "aws_iam_openid_connect_provider" "github" {
  url             = local.gh_oidc_url
  client_id_list  = [local.gh_oidc_client_id]
  thumbprint_list = [local.gh_oidc_thumbprint]
}

# =============================================================================
# Staging Environment IAM
# =============================================================================

data "aws_iam_policy_document" "github_actions_assume_staging" {
  statement {
    sid     = "GitHubActionsStagingAssumeRole"
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

resource "aws_iam_role" "github_actions_staging" {
  name               = "github-actions-terraform-staging"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_staging.json
}

resource "aws_iam_policy" "terraform_state_staging" {
  name = "terraform-state-access-staging"
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
          "arn:aws:s3:::${local.state_s3_bucket_staging}",
          "arn:aws:s3:::${local.state_s3_bucket_staging}/*",
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
      },
      {
        Sid    = "ManageProdStateLocks"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${local.state_s3_bucket_prod}/*.tflock"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_staging" {
  role       = aws_iam_role.github_actions_staging.name
  policy_arn = aws_iam_policy.terraform_state_staging.arn
}

# =============================================================================
# Prod Environment IAM
# =============================================================================

data "aws_iam_policy_document" "github_actions_assume_prod" {
  statement {
    sid     = "GitHubActionsProdAssumeRole"
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

resource "aws_iam_role" "github_actions_prod" {
  name               = "github-actions-terraform-prod"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_prod.json
}

resource "aws_iam_policy" "terraform_state_prod" {
  name = "terraform-state-access-prod"
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
          "arn:aws:s3:::${local.state_s3_bucket_prod}",
          "arn:aws:s3:::${local.state_s3_bucket_prod}/*",
          "arn:aws:s3:::${local.state_s3_bucket_shared}",
          "arn:aws:s3:::${local.state_s3_bucket_shared}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_prod" {
  role       = aws_iam_role.github_actions_prod.name
  policy_arn = aws_iam_policy.terraform_state_prod.arn
}
