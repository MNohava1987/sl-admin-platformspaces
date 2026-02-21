# --- 1) CORE PLATFORM CONTAINER ---

resource "spacelift_space" "platform" {
  name            = "Platform"
  inherit_entities = true
  parent_space_id = data.spacelift_space_by_path.admin.id
  description     = "Foundation for all platform-level infrastructure"
}

# --- 2) ENVIRONMENT HIERARCHY ---

resource "spacelift_space" "dev" {
  name            = "Dev"
  inherit_entities = true
  parent_space_id = spacelift_space.platform.id
  description     = "Development and Sandbox workloads"
}

resource "spacelift_space" "test" {
  name            = "Test"
  inherit_entities = true
  parent_space_id = spacelift_space.platform.id
  description     = "Testing, Staging, and QA workloads"
}

resource "spacelift_space" "prod" {
  name            = "Prod"
  inherit_entities = true
  parent_space_id = spacelift_space.platform.id
  description     = "Production critical workloads"
}

# --- 3) CLOUD PROVIDER ISOLATION ---

resource "spacelift_space" "azure" {
  name            = "Azure"
  inherit_entities = true
  parent_space_id = spacelift_space.platform.id
  description     = "Isolation boundary for Azure-native resources"
}

resource "spacelift_space" "gcp" {
  name            = "GCP"
  inherit_entities = true
  parent_space_id = spacelift_space.platform.id
  description     = "Isolation boundary for GCP-native resources"
}

resource "spacelift_space" "private_cloud" {
  name            = "Private Cloud"
  inherit_entities = true
  parent_space_id = spacelift_space.platform.id
  description     = "Isolation boundary for On-Premise / Private Cloud resources"
}
