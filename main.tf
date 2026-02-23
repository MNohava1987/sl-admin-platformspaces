# Tier-3 platform and workload space hierarchy for one environment.

# Create sibling platform spaces under environment root.
resource "spacelift_space" "base" {
  for_each = local.managed_base_spaces

  name             = each.key
  parent_space_id  = data.spacelift_space_by_path.env_root.id
  description      = "${each.value.description} for ${var.environment_name}."
  inherit_entities = true
  labels = [
    "environment:${lower(var.environment_name)}",
    "assurance:${var.assurance_tier}",
    "governance:env-guard"
  ]
}

# Create cloud boundaries under customer.
resource "spacelift_space" "clouds" {
  for_each = local.managed_clouds

  name             = each.key
  parent_space_id  = spacelift_space.base["customer"].id
  description      = "Isolation boundary for ${each.key} resources."
  inherit_entities = true
  labels = [
    "environment:${lower(var.environment_name)}",
    "assurance:${var.assurance_tier}",
    "governance:env-guard"
  ]
}

# Create workload environments under each cloud.
resource "spacelift_space" "workloads" {
  for_each = local.managed_env_spaces

  name             = each.value.env_name
  parent_space_id  = spacelift_space.clouds[each.value.cloud_name].id
  description      = "${each.value.cloud_name} ${each.value.env_name} workload environment."
  inherit_entities = true
  labels = [
    "environment:${lower(var.environment_name)}",
    "assurance:${var.assurance_tier}",
    "governance:env-guard"
  ]
}
