# Path: infra/modules/networking/zone/variables.tf

variable "root_domain" {
  description = "Root domain (e.g., mydomain.com)"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}
