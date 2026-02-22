# --- Manifest Contracts ---

check "manifest_structure" {
  assert {
    condition = (
      can(local.workload_data.base_spaces) &&
      can(tolist(local.workload_data.base_spaces)) &&
      can(local.workload_data.clouds) &&
      can(tolist(local.workload_data.clouds))
    )
    error_message = "The 'base_spaces' and/or 'clouds' keys are missing from workloads.yaml or are not valid lists."
  }
}

check "manifest_version_supported" {
  assert {
    condition     = contains(var.supported_manifest_versions, try(local.workload_data.manifest_version, "missing"))
    error_message = "The manifest_version defined in workloads.yaml is not supported or missing. Expected: ${join(", ", var.supported_manifest_versions)}"
  }
}

check "cloud_names_unique_case_insensitive" {
  assert {
    condition     = length(distinct(local.cloud_names_lower)) == length(local.cloud_names_lower)
    error_message = "Duplicate cloud names (case-insensitive) detected in workloads.yaml."
  }
}

check "cloud_names_lowercase" {
  assert {
    condition     = !var.enforce_lowercase_cloud_names || alltrue([for n in local.cloud_names : n == lower(n)])
    error_message = "One or more cloud names in workloads.yaml contain uppercase characters."
  }
}

check "workload_environment_names_lowercase" {
  assert {
    condition     = !var.enforce_lowercase_workload_environment_names || alltrue([for n in local.workload_env_names : n == lower(n)])
    error_message = "One or more workload environment names in workloads.yaml contain uppercase characters."
  }
}

check "cloud_environment_keys_unique_case_insensitive" {
  assert {
    condition     = length(distinct(local.cloud_env_keys_lower)) == length(local.cloud_env_keys_lower)
    error_message = "Duplicate cloud/environment combinations (case-insensitive) detected in workloads.yaml."
  }
}

check "cloud_required_fields" {
  assert {
    condition = alltrue([
      for c in local.raw_clouds : (
        try(c.name, "") != "" &&
        can(tolist(try(c.environments, []))) &&
        length(try(c.environments, [])) > 0
      )
    ])
    error_message = "Each cloud in workloads.yaml must define a non-empty name and at least one environment."
  }
}

check "environment_entries_non_empty" {
  assert {
    condition     = alltrue([for e in local.workload_env_names : try(e, "") != ""])
    error_message = "Cloud environment entries in workloads.yaml must be non-empty strings."
  }
}

check "base_space_names_unique_case_insensitive" {
  assert {
    condition     = length(distinct(local.base_space_names_lower)) == length(local.base_space_names_lower)
    error_message = "Duplicate base space names (case-insensitive) detected in workloads.yaml."
  }
}

check "base_space_required_fields" {
  assert {
    condition = alltrue([
      for s in local.raw_base_spaces : (
        try(s.name, "") != "" &&
        try(s.description, "") != ""
      )
    ])
    error_message = "Each base space in workloads.yaml must define non-empty name and description."
  }
}

check "manifest_settings_flags_boolean" {
  assert {
    condition = alltrue([
      can(tobool(local.cfg_enable_component)),
      can(tobool(local.cfg_enable_deletion_protection)),
      can(tobool(local.cfg_repave_mode))
    ])
    error_message = "workloads.yaml settings flags (enable_component, enable_deletion_protection, repave_mode) must be boolean."
  }
}

check "clouds_require_customer_base_space" {
  assert {
    condition     = length(local.managed_clouds) == 0 || contains(keys(local.managed_base_spaces), "customer")
    error_message = "When clouds are enabled, base_spaces must include an enabled 'customer' space."
  }
}

# --- Runtime Controls ---

check "space_inheritance_consistency" {
  assert {
    condition = alltrue(concat(
      [for s in spacelift_space.base : s.inherit_entities == true],
      [for s in spacelift_space.clouds : s.inherit_entities == true],
      [for s in spacelift_space.workloads : s.inherit_entities == true]
    ))
    error_message = "All platform/workload spaces must inherit entities from their parent by design."
  }
}

check "destructive_changes_require_repave_mode" {
  assert {
    condition     = local.cfg_enable_deletion_protection || local.cfg_repave_mode
    error_message = "Disabling deletion protection requires repave_mode=true for explicit operator intent."
  }
}
