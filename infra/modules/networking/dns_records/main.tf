# Path: infra/modules/networking/dns_records/main.tf

# The Worker route is managed in wrangler.jsonc via environment configuration.
#
# To deploy the staging worker:
#   cd apps/web && pnpm run build && wrangler deploy --env staging
#
# The staging environment in wrangler.jsonc configures:
#   - Worker name: web-staging
#   - Route: staging.tlds.guide/*

# Placeholder AAAA record required for Worker routes on subdomains.
# The actual traffic is handled by the Worker, not this IP.
# Using the conventional "100::" address as a placeholder.
resource "cloudflare_dns_record" "subdomain" {
  zone_id = var.cloudflare_zone_id
  name    = var.subdomain
  type    = "AAAA"
  content = "100::"
  proxied = true
  ttl     = 1 # Auto TTL when proxied
}
