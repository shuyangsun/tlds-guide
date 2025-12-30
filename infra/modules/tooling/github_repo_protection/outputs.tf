# Path: infra/modules/tooling/github_repo_protection/outputs.tf

# TODO: Re-enable main branch push protection when ready
# output "branch_protection_id" {
#   description = "The ID of the branch protection rule"
#   value       = github_branch_protection.main.id
# }

output "tag_ruleset_id" {
  description = "The ID of the tag protection ruleset"
  value       = github_repository_ruleset.tags.id
}

output "tag_ruleset_node_id" {
  description = "The GraphQL node ID of the tag protection ruleset"
  value       = github_repository_ruleset.tags.node_id
}
