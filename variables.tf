variable "spacelift_api_key_id" {
  type      = string
  sensitive = true
}

variable "spacelift_api_key_secret" {
  type      = string
  sensitive = true
}

variable "admin_space_id" {
  type        = string
  description = "The ID of the parent Admin space (injected by orchestrator)"
}
