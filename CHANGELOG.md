# Changelog

All notable changes to the Spacelift Platform Spaces hierarchy will be documented in this file.

## [1.1.0] - 2026-02-22
### Added
- Manifest contract checks in `checks.tf` for schema, version, lowercase policy, and required fields.
- Safe workload locals in `locals.tf` for robust parsing and deterministic resource generation.
- Assurance scripts:
  - `scripts/validate-contract.sh`
  - `scripts/assurance-gate.sh`
- Operations guide in `docs/OPERATIONS.md`.

### Changed
- Environment root path resolution now follows canonical naming (`sl-<env>-mgmt-env-root-space`).
- Workload manifest upgraded to include `manifest_version`.
- README rewritten to match root/bootstrap documentation style.
- Provider and version constraints aligned with other orchestration repositories.

### Fixed
- Removed legacy API-key variable dependency from provider configuration.
- Normalized cloud and workload environment names in manifest to lowercase-safe tokens.

## [1.0.0] - 2026-02-20
### Added
- Hierarchical space structure for Platform, Environments (Dev, Test, Prod), and Cloud Providers.
- Dynamic parent lookup via `spacelift_space_by_path`.
- Professional directory structure and documentation.
- Automated code quality gates.
