# Path: infra/global/zone/outputs.tf

output "cloudflare_nameservers" {
  description = "Cloudflare nameservers assigned to the zone"
  value       = cloudflare_zone.primary_domain.name_servers
}

output "cloudflare_zone_status" {
  description = "Cloudflare zone status (should be 'active' when nameservers are verified)"
  value       = cloudflare_zone.primary_domain.status
}
