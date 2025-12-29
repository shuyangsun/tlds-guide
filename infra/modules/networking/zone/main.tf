# Path: infra/modules/networking/zone/main.tf

resource "cloudflare_zone" "primary_domain" {
  account = {
    id = var.cloudflare_account_id
  }
  name = var.root_domain
  type = "full"

  lifecycle {
    prevent_destroy = true
  }
}

resource "porkbun_domain_nameservers" "primary_domain" {
  domain      = var.root_domain
  nameservers = resource.cloudflare_zone.primary_domain.name_servers

  lifecycle {
    prevent_destroy = true
  }
}
