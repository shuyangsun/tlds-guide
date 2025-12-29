# Path: infra/global/networking/zone/main.tf

module "zone" {
  source = "../../../modules/networking/zone"

  root_domain           = var.root_domain
  cloudflare_account_id = var.cloudflare_account_id
}
