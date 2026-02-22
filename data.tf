# Resolve environment root space using canonical naming.
data "spacelift_space_by_path" "env_root" {
  space_path = "root/${local.env_root_space_name}"
}
