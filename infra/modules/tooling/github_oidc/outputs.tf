# Path: infra/modules/tooling/github_oidc/outputs.tf

output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "staging_role_arn" {
  description = "ARN of the staging GitHub Actions IAM role"
  value       = aws_iam_role.github_actions_staging.arn
}

output "prod_role_arn" {
  description = "ARN of the prod GitHub Actions IAM role"
  value       = aws_iam_role.github_actions_prod.arn
}
