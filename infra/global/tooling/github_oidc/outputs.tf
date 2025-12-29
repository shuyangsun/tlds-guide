# Path: infra/global/tooling/github_oidc/outputs.tf

output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = module.github_oidc.oidc_provider_arn
}

output "staging_role_arn" {
  description = "ARN of the staging GitHub Actions IAM role"
  value       = module.github_oidc.staging_role_arn
}

output "prod_role_arn" {
  description = "ARN of the prod GitHub Actions IAM role"
  value       = module.github_oidc.prod_role_arn
}
