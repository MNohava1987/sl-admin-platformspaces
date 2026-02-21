# Example hierarchy (customize)
resource "spacelift_space" "platform" {
  space_id = "platform"
  name     = "Platform"
}

resource "spacelift_space" "modules" {
  space_id  = "modules"
  name      = "Modules"
  parent_id = spacelift_space.platform.space_id
}

resource "spacelift_space" "customers" {
  space_id  = "customers"
  name      = "Customers"
  parent_id = spacelift_space.platform.space_id
}

# Example env containers
resource "spacelift_space" "gcp" {
  space_id  = "gcp"
  name      = "GCP"
  parent_id = spacelift_space.customers.space_id
}

resource "spacelift_space" "azure" {
  space_id  = "azure"
  name      = "Azure"
  parent_id = spacelift_space.customers.space_id
}
