# Path: infra/modules/networking/zone/outputs.tf

output "cloudflare_zone_status" {
  description = "Cloudflare zone status (should be 'active' when nameservers are verified)"
  value       = cloudflare_zone.primary_domain.status
}

output "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  value       = cloudflare_zone.primary_domain.id
  sensitive   = false
}
