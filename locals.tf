locals {
  workload_manifest_path = "${path.module}/manifests/workloads.yaml"
  workload_data          = yamldecode(file(local.workload_manifest_path))

  # Raw lookup keeps contract checks strict.
  raw_base_spaces_key = lookup(local.workload_data, "base_spaces", "MISSING_KEY")
  raw_clouds_key      = lookup(local.workload_data, "clouds", "MISSING_KEY")

  cfg_enable_component           = try(local.workload_data.settings.enable_component, true)
  cfg_enable_deletion_protection = try(local.workload_data.settings.enable_deletion_protection, var.enable_deletion_protection)
  cfg_repave_mode                = try(local.workload_data.settings.repave_mode, var.repave_mode)

  # Safe fallback for generation paths.
  raw_base_spaces = try(
    [for s in local.workload_data.base_spaces : s],
    []
  )

  # Safe fallback for generation paths.
  raw_clouds = try(
    [for c in local.workload_data.clouds : c],
    []
  )

  base_space_names       = [for s in local.enabled_base_spaces : try(s.name, "")]
  base_space_names_lower = [for n in local.base_space_names : lower(n)]

  cloud_names       = [for c in local.enabled_clouds : try(c.name, "")]
  cloud_names_lower = [for n in local.cloud_names : lower(n)]

  workload_env_names = flatten([
    for c in local.enabled_clouds : [for e in try(c.environments, []) : e]
  ])
  workload_env_names_lower = [for e in local.workload_env_names : lower(e)]

  cloud_env_keys_lower = flatten([
    for c in local.enabled_clouds : [
      for e in try(c.environments, []) : lower("${try(c.name, "")}/${try(e, "")}")
    ]
  ])

  enabled_base_spaces = [
    for s in local.raw_base_spaces : s
    if local.cfg_enable_component && try(s.enabled, true)
  ]

  base_spaces = {
    for s in local.enabled_base_spaces : s.name => {
      description = try(s.description, "")
    }
    if try(s.name, "") != ""
  }

  enabled_clouds = [
    for c in local.raw_clouds : c
    if local.cfg_enable_component && try(c.enabled, true)
  ]

  clouds = {
    for c in local.enabled_clouds : c.name => c
    if try(c.name, "") != ""
  }

  env_spaces_list = flatten([
    for c in local.enabled_clouds : [
      for e in try(c.environments, []) : {
        cloud_name = c.name
        env_name   = e
        key        = "${c.name}/${e}"
      } if try(c.name, "") != "" && try(e, "") != ""
    ]
  ])

  env_spaces = { for s in local.env_spaces_list : s.key => s }

  managed_base_spaces = local.cfg_enable_component ? local.base_spaces : {}
  managed_clouds      = local.cfg_enable_component ? local.clouds : {}
  managed_env_spaces  = local.cfg_enable_component ? local.env_spaces : {}

  env_root_space_name = "${var.naming_org}-${lower(var.environment_name)}-${var.naming_domain}-${var.naming_function_env_root_space}"
}
