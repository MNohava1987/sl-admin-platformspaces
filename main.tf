locals {
  workload_data = yamldecode(file("${path.module}/manifests/workloads.yaml"))

  # Flatten cloud -> env for sub-spaces
  env_spaces_list = flatten([
    for cloud in local.workload_data.clouds : [
      for env in cloud.environments : {
        cloud_name = cloud.name
        env_name   = env
        key        = "${cloud.name}/${env}"
      }
    ]
  ])
  env_spaces = { for s in local.env_spaces_list : s.key => s }
}

# --- 1) TIER 1 SIBLINGS (Under root/Environment) ---

# Modules Space
resource "spacelift_space" "modules" {
  name            = "Modules"
  parent_space_id = data.spacelift_space_by_path.env_root.id
  description     = "Reusable code registry for ${var.environment_name}"
  inherit_entities = true
}

# Customer Space (The Workload Container)
resource "spacelift_space" "customer" {
  name            = "Customer"
  parent_space_id = data.spacelift_space_by_path.env_root.id
  description     = "Production and Non-Production Workloads for ${var.environment_name}"
  inherit_entities = true
}

# Sandbox Space
resource "spacelift_space" "sandbox" {
  name            = "Sandbox"
  parent_space_id = data.spacelift_space_by_path.env_root.id
  description     = "Experimentation and Scratch space for ${var.environment_name}"
  inherit_entities = true
}

# --- 2) TIER 2 CLOUD PROVIDERS (Under Customer) ---

resource "spacelift_space" "clouds" {
  for_each        = { for c in local.workload_data.clouds : c.name => c }
  name            = each.key
  parent_space_id = spacelift_space.customer.id
  description     = "Isolation boundary for ${each.key} resources"
  inherit_entities = true
}

# --- 3) TIER 3 WORKLOAD ENVIRONMENTS (Under Cloud) ---

resource "spacelift_space" "workloads" {
  for_each        = local.env_spaces
  name            = each.value.env_name
  parent_space_id = spacelift_space.clouds[each.value.cloud_name].id
  description     = "${each.value.cloud_name} ${each.value.env_name} environment"
  inherit_entities = true
}
