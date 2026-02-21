# Dynamic lookup for the Admin space to ensure correct nesting.
data "spacelift_space_by_path" "admin" {
  space_path = "root/Admin"
}
