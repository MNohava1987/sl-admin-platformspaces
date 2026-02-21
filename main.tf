# --- 1) CORE PLATFORM CONTAINER ---

resource "spacelift_space" "platform" {
  name            = "Platform"
  parent_space_id = data.spacelift_space_by_path.admin.id
  description     = "Foundation for all platform-level infrastructure"
  inherit_entities = true
}

# --- 2) CLOUD PROVIDER CONTAINERS ---

resource "spacelift_space" "azure" {
  name            = "Azure"
  parent_space_id = spacelift_space.platform.id
  description     = "Isolation boundary for Azure resources"
  inherit_entities = true
}

resource "spacelift_space" "gcp" {
  name            = "GCP"
  parent_space_id = spacelift_space.platform.id
  description     = "Isolation boundary for GCP resources"
  inherit_entities = true
}

resource "spacelift_space" "private_cloud" {
  name            = "Private Cloud"
  parent_space_id = spacelift_space.platform.id
  description     = "Isolation boundary for On-Premise / Private Cloud resources"
  inherit_entities = true
}

# --- 3) ENVIRONMENT HIERARCHY (PER CLOUD) ---

# Azure Environments
resource "spacelift_space" "azure_dev" {
  name            = "Dev"
  parent_space_id = spacelift_space.azure.id
  description     = "Azure Development Environment"
  inherit_entities = true
}
resource "spacelift_space" "azure_test" {
  name            = "Test"
  parent_space_id = spacelift_space.azure.id
  description     = "Azure Testing Environment"
  inherit_entities = true
}
resource "spacelift_space" "azure_prod" {
  name            = "Prod"
  parent_space_id = spacelift_space.azure.id
  description     = "Azure Production Environment"
  inherit_entities = true
}

# GCP Environments
resource "spacelift_space" "gcp_dev" {
  name            = "Dev"
  parent_space_id = spacelift_space.gcp.id
  description     = "GCP Development Environment"
  inherit_entities = true
}
resource "spacelift_space" "gcp_test" {
  name            = "Test"
  parent_space_id = spacelift_space.gcp.id
  description     = "GCP Testing Environment"
  inherit_entities = true
}
resource "spacelift_space" "gcp_prod" {
  name            = "Prod"
  parent_space_id = spacelift_space.gcp.id
  description     = "GCP Production Environment"
  inherit_entities = true
}

# Private Cloud Environments
resource "spacelift_space" "private_dev" {
  name            = "Dev"
  parent_space_id = spacelift_space.private_cloud.id
  description     = "Private Cloud Development Environment"
  inherit_entities = true
}
resource "spacelift_space" "private_test" {
  name            = "Test"
  parent_space_id = spacelift_space.private_cloud.id
  description     = "Private Cloud Testing Environment"
  inherit_entities = true
}
resource "spacelift_space" "private_prod" {
  name            = "Prod"
  parent_space_id = spacelift_space.private_cloud.id
  description     = "Private Cloud Production Environment"
  inherit_entities = true
}
