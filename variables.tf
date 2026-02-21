variable "spacelift_api_key_id" {
  type      = string
  sensitive = true
}

variable "spacelift_api_key_secret" {
  type      = string
  sensitive = true
}

# The name of the environment (e.g. "Prod", "Staging")
# Injected by the admin-stacks orchestrator.
variable "environment_name" {
  type        = string
  description = "Name of the environment container"
}

# admin_space_id is now handled by data lookup
variable "admin_space_id" {
  type    = string
  default = ""
}

variable "vcs_integration_id" {
  type    = string
  default = ""
}
