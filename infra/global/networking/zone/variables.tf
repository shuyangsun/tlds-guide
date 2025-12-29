# Path: infra/global/networking/zone/variables.tf

variable "root_domain" {
  description = "Root domain (e.g., mydomain.com)"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "porkbun_api_key" {
  description = "porkbun API key"
  type        = string
}

variable "porkbun_secret_key" {
  description = "porkbun secret key"
  type        = string
}
