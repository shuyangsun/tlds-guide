# Path: infra/prod/networking/versions.tf

terraform {
  required_version = "~> 1.14.3"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.15.0"
    }
  }
}
