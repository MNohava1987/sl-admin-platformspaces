# Spacelift Platform Spaces (Tier 3)

This repository defines the Tier-3 platform and workload space hierarchy for one environment.

## Purpose

This stack creates:
1. Environment sibling spaces: `modules`, `customer`, `sandbox`.
2. Cloud boundaries under `customer`.
3. Workload environment spaces under each cloud.

## Manifest-Driven Topology

Topology is defined in `manifests/workloads.yaml`.

Contract highlights:
- `manifest_version` must be supported (default: `"1"`).
- Cloud names must be unique and lowercase by default.
- Workload environment names must be lowercase by default.
- Each cloud must define at least one environment.

## Runtime Pathing

Environment root is resolved using root naming defaults:
- `root/sl-<env>-mgmt-env-root-space`

## Local Validation

Run before commit:
`./scripts/assurance-gate.sh`
