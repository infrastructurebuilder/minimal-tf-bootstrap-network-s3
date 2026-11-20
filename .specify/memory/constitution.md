# minimal-tf-bootstrap-network-s3 Constitution

## Core Principles

### I. Minimal by Design

- The module creates only what has to exist before anything else can be deployed: a VPC
  with public and private subnets, an internet gateway with public routing, the state
  bucket with its access policies and roles, and the load-balancer log bucket.
- A new resource MUST be something a later stage cannot create for itself. Anything that
  can live in a later stage belongs there.
- The module MUST stay usable on an empty account. It MUST NOT depend on a resource it
  does not create.

Rationale: this is the first thing applied to a new account and the last thing destroyed.
Every extra resource here is one more thing that can never be changed lightly.

### II. The State Bucket Is Protected

- The state bucket MUST keep versioning, encryption at rest, a full public-access block and
  a policy that denies requests not made over TLS.
- The state bucket MUST keep `prevent_destroy`.
- A change that would replace, rename or delete the state bucket is a breaking change under
  Principle IV, and the change MUST say how existing state is carried across.

Rationale: every later stage keeps its state in this bucket. Losing it, or exposing it,
loses or exposes all of them.

### III. Least-Privilege State Access

- The module provides three levels of access to state, each as a policy and a role: admin,
  read-only and restricted-write.
- Every policy is scoped to keys under `state/`. Restricted-write MUST NOT be able to write
  keys under `state/protected/`.
- A change to the key layout those policies rely on is a breaking change under
  Principle IV.

Rationale: state files hold whatever the stages that write them hold, including secrets.
Scoped roles let a stage read what it needs and write only what is its own.

### IV. A Contract for Later Stages

- Public subnets are tagged `Tier = Public` and private subnets `Tier = Private`. Later
  stages find subnets by those tags, so the tags are part of the interface.
- Every variable and output MUST have a description. Every declared input MUST be used; an
  input that is accepted and ignored is a defect.
- The module MUST declare the Terraform and provider versions it supports, and MUST NOT
  configure a provider.
- Releases are tagged with semantic versions, and consumers pin a tag. A MAJOR change is
  any of: renaming or removing an input or output; changing the subnet tags or the state
  key layout; changing a resource address so that the VPC, a subnet or a bucket is
  recreated.

Rationale: other stages are built on these outputs and tags and cannot see inside the
module. A silent change here surfaces as a broken plan somewhere else.

### V. The Justfile Is the Entry Point and the Gate

- The Justfile MUST provide `init`, `build`, `test`, `full-test` and `release`, and
  `release` MUST depend on `full-test`.
- `just test` MUST check formatting and validate the module. It MUST pass before a change
  is merged.
- People, CI and agents run `just <target>`, not the underlying tool. A missing check is
  added as a target, not run by hand.

Rationale: the same verbs in every repo mean nobody has to rediscover how this one is
checked, and a gate at the desk catches what would otherwise surface in a consumer's plan.

## Compatibility and Layout

- The module sits at the repository root: `main.tf` for the network and the buckets,
  `iam_policies.tf` for state access, `variables.tf` and `outputs.tf` for the interface.
- It is written for the `hashicorp/aws` provider and is consumed as a child module. The
  caller configures the provider and owns the state.

## Development Workflow

- Features follow the Spec Kit sequence: `/speckit-specify`, `/speckit-plan`,
  `/speckit-tasks`, `/speckit-implement`. Their artifacts live in `specs/<NNN-name>/`.
- The root `PLAN.md` is the index of plans. Every feature MUST have one `##` section there,
  newest first, with a `*Status:*` line and a repo-relative link to
  `specs/<NNN-name>/plan.md`. The status line MUST be kept current as the feature progresses.
- Every plan's Constitution Check MUST list Principles I to V and record a pass or a
  justified violation for each. It MUST also confirm that the feature's `PLAN.md` entry
  exists.
- Changes are kept small enough to review, and documentation lands with the change it
  describes.
- Features are developed on a `feature/<name>` branch and squash-merged into the
  integration branch, `develop`.
- Releases follow git-flow. A release is staged on a `release/<version>` branch and
  finished into `main`, where it is tagged. `main` is the production branch.
- The `master` branch is retired and replaced by `main`. Nothing may be based on `master`
  or pin it as a ref.

## Governance

- This constitution takes precedence over other practice in this repository. Where a plan
  conflicts with it, either the plan changes or the constitution is amended first.
- An amendment is a change to this file with a stated rationale. It takes effect when a
  maintainer merges it.
- Versions follow semantic versioning. MAJOR removes or redefines a principle. MINOR adds a
  principle or a section, or materially expands one. PATCH clarifies wording.
- Compliance is checked in every plan's Constitution Check and again at review. A violation
  that is accepted MUST be justified in the plan's Complexity Tracking table.
- Day-to-day usage guidance belongs in `README.md`.

**Version**: 1.0.0 | **Ratified**: 2026-11-20 | **Last Amended**: 2026-11-20
