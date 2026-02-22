locals {
  workload_manifest_path = "${path.module}/manifests/workloads.yaml"
  workload_data          = yamldecode(file(local.workload_manifest_path))

  # Raw lookup keeps contract checks strict.
  raw_clouds_key = lookup(local.workload_data, "clouds", "MISSING_KEY")

  # Safe fallback for generation paths.
  raw_clouds_list = try(local.workload_data.clouds, [])
  raw_clouds      = local.raw_clouds_list == null ? [] : local.raw_clouds_list

  cloud_names       = [for c in local.raw_clouds : try(c.name, "")]
  cloud_names_lower = [for n in local.cloud_names : lower(n)]

  workload_env_names = flatten([
    for c in local.raw_clouds : [for e in try(c.environments, []) : e]
  ])
  workload_env_names_lower = [for e in local.workload_env_names : lower(e)]

  cloud_env_keys_lower = flatten([
    for c in local.raw_clouds : [
      for e in try(c.environments, []) : lower("${try(c.name, "")}/${try(e, "")}")
    ]
  ])

  clouds = {
    for c in local.raw_clouds : c.name => c
    if try(c.name, "") != ""
  }

  env_spaces_list = flatten([
    for c in local.raw_clouds : [
      for e in try(c.environments, []) : {
        cloud_name = c.name
        env_name   = e
        key        = "${c.name}/${e}"
      } if try(c.name, "") != "" && try(e, "") != ""
    ]
  ])

  env_spaces = { for s in local.env_spaces_list : s.key => s }

  env_root_space_name = "${var.naming_org}-${lower(var.environment_name)}-${var.naming_domain}-${var.naming_function_env_root_space}"
}
