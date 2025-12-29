# Path: infra/global/networking/zone/versions.tf

# Path: terraform/global/networking/dns/versions.tf

terraform {
  required_version = "~> 1.14.3"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.15.0"
    }
    porkbun = {
      source  = "jianyuan/porkbun"
      version = "= 0.2.1"
    }
  }
}
