# Path: infra/modules/networking/dns_records/variables.tf

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "subdomain" {
  description = "Subdomain name (e.g., \"staging\")"
  type        = string
}
