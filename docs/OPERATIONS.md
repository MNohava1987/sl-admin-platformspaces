# Platform Spaces Operations

This guide covers operation of the `sl-admin-platformspaces` Tier-3 stack.

## Managing Workload Topology

The hierarchy is driven by `manifests/workloads.yaml`.

Manifest standards:
- `manifest_version` must match one of `supported_manifest_versions` (default: `"1"`).
- Cloud names must be unique (case-insensitive).
- Cloud and environment names are lowercase by default.
- Each cloud entry must include at least one environment.

## Update Flow

1. Edit `manifests/workloads.yaml`.
2. Run `./scripts/assurance-gate.sh`.
3. Run a local preview or plan in Spacelift.
4. Apply after review.

## Dependency Note

This stack expects the environment root space to exist first:
- `root/sl-<env>-mgmt-env-root-space`

If that path does not exist, run `sl-root-bootstrap` and `sl-admin-stacks` first.
