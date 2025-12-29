# Path: infra/staging/networking/main.tf

# The Worker route is managed in wrangler.jsonc via environment configuration.
#
# To deploy the staging worker:
#   cd apps/web && pnpm run build && wrangler deploy --env staging
#
# The staging environment in wrangler.jsonc configures:
#   - Worker name: web-staging
#   - Route: staging.tlds.guide/*

module "dns_records" {
  source = "../../modules/networking/dns_records"

  subdomain          = "staging"
  cloudflare_zone_id = var.cloudflare_zone_id
}
