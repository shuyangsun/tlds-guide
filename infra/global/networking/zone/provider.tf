# Path: infra/global/networking/zone/provider.tf

provider "cloudflare" {}

provider "porkbun" {
  api_key    = var.porkbun_api_key
  secret_key = var.porkbun_secret_key
}
