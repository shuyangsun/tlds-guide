# Path: infra/global/networking/zone/outputs.tf

output "cloudflare_zone_status" {
  description = "Cloudflare zone status (should be 'active' when nameservers are verified)"
  value       = module.zone.cloudflare_zone_status
}

output "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  value       = module.zone.cloudflare_zone_id
  sensitive   = true
}
