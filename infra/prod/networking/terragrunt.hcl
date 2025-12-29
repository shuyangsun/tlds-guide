include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "global_zone" {
  config_path = "../../global/networking/zone"

  mock_outputs = {
    cloudflare_zone_id = "mock-zone-id"
  }
}

inputs = {
  cloudflare_zone_id = dependency.global_zone.outputs.cloudflare_zone_id
}
