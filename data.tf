# Dynamic parent lookup based on the environment name.
# Path format: root/<environment_name>/Admin
data "spacelift_space_by_path" "admin" {
  space_path = "root/${var.environment_name}/Admin"
}

# Lookup for the Environment Root (to place Platform/Customer sibling to Admin)
data "spacelift_space_by_path" "env_root" {
  space_path = "root/${var.environment_name}"
}
