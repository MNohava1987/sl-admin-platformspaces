variable "environment_name" {
  type        = string
  description = "Environment name managed by this stack."
}

variable "assurance_tier" {
  type        = string
  description = "Assurance tier inherited from the parent orchestrator."
}

variable "naming_org" {
  type        = string
  default     = "sl"
  description = "Organization token used by the naming convention."
}

variable "naming_domain" {
  type        = string
  default     = "mgmt"
  description = "Domain token used by the naming convention."
}

variable "naming_function_env_root_space" {
  type        = string
  default     = "env-root-space"
  description = "Function token for top-level environment root spaces."
}

variable "supported_manifest_versions" {
  type        = list(string)
  default     = ["1"]
  description = "Allowed versions for manifests/workloads.yaml."
}

variable "enforce_lowercase_cloud_names" {
  type        = bool
  default     = true
  description = "When true, cloud names in workloads.yaml must be lowercase."
}

variable "enforce_lowercase_workload_environment_names" {
  type        = bool
  default     = true
  description = "When true, workload environment names in workloads.yaml must be lowercase."
}
