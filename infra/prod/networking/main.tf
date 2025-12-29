# Path: infra/prod/networking/main.tf

# The Worker route is managed in wrangler.jsonc via environment configuration.
#
# To deploy the staging worker:
#   cd apps/web && pnpm run deoploy
#
# The prod environment in wrangler.jsonc configures:
#   - Worker name: tlds-guide-prod
#   - Route: tlds.guide/*

module "dns_records" {
  source = "../../modules/networking/dns_records"

  subdomain          = "@"
  cloudflare_zone_id = var.cloudflare_zone_id
}
