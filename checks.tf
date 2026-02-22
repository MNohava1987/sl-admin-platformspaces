# --- Manifest Contracts ---

check "manifest_structure" {
  assert {
    condition     = local.raw_clouds_key != "MISSING_KEY" && can(tolist(local.raw_clouds_key))
    error_message = "The 'clouds' key is missing from workloads.yaml or is not a valid list."
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

# --- Runtime Controls ---

check "space_inheritance_consistency" {
  assert {
    condition = alltrue(concat(
      [for s in spacelift_space.clouds : s.inherit_entities == true],
      [for s in spacelift_space.workloads : s.inherit_entities == true],
      [
        spacelift_space.modules.inherit_entities == true,
        spacelift_space.customer.inherit_entities == true,
        spacelift_space.sandbox.inherit_entities == true
      ]
    ))
    error_message = "All platform/workload spaces must inherit entities from their parent by design."
  }
}

check "destructive_changes_require_repave_mode" {
  assert {
    condition     = var.enable_deletion_protection || var.repave_mode
    error_message = "Disabling deletion protection requires repave_mode=true for explicit operator intent."
  }
}
