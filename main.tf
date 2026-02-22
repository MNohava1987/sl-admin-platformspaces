# Tier-3 platform and workload space hierarchy for one environment.

# Create sibling platform spaces under environment root.
resource "spacelift_space" "modules" {
  name             = "modules"
  parent_space_id  = data.spacelift_space_by_path.env_root.id
  description      = "Reusable code registry for ${var.environment_name}."
  inherit_entities = true
}

resource "spacelift_space" "customer" {
  name             = "customer"
  parent_space_id  = data.spacelift_space_by_path.env_root.id
  description      = "Managed workload container for ${var.environment_name}."
  inherit_entities = true
}

resource "spacelift_space" "sandbox" {
  name             = "sandbox"
  parent_space_id  = data.spacelift_space_by_path.env_root.id
  description      = "Experimentation and scratch space for ${var.environment_name}."
  inherit_entities = true
}

# Create cloud boundaries under customer.
resource "spacelift_space" "clouds" {
  for_each         = local.clouds
  name             = each.key
  parent_space_id  = spacelift_space.customer.id
  description      = "Isolation boundary for ${each.key} resources."
  inherit_entities = true
}

# Create workload environments under each cloud.
resource "spacelift_space" "workloads" {
  for_each         = local.env_spaces
  name             = each.value.env_name
  parent_space_id  = spacelift_space.clouds[each.value.cloud_name].id
  description      = "${each.value.cloud_name} ${each.value.env_name} workload environment."
  inherit_entities = true
}
