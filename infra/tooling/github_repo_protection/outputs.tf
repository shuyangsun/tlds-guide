# Path: infra/tooling/github_repo_protection/outputs.tf

output "branch_protection_id" {
  description = "The ID of the branch protection rule"
  value       = module.github_repo_protection.branch_protection_id
}

output "tag_ruleset_id" {
  description = "The ID of the tag protection ruleset"
  value       = module.github_repo_protection.tag_ruleset_id
}
