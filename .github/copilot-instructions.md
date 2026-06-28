# terraform-google-bootstrap

> Baseline engineering guidance for this repository, **shared with the team**. Applies to AI coding
> assistants (Claude Code, Gemini, Codex, GitHub Copilot) and humans alike. Self-contained and tool-agnostic —
> edit freely. (This is the team's standard file; any private/framework wiring lives elsewhere.)
>
> **Public-safe:** this file is committed and may be public. Keep it to **generic standards + only
> non-identifying context**. Do NOT put personal names, employer/client names, concrete cloud
> project/account IDs, state-bucket names, or internal hostnames here — those belong in the private,
> un-pushed complement, not a shared/public repo.

## Project context
- **Purpose:** Reusable Terraform module that bootstraps a GCP project foundation — optionally a
  folder, a project (with a random suffix), baseline API enablement, a Terraform automation service
  account with impersonation bindings, and a GCS bucket for remote state. Published to the Terraform
  Registry and consumed by downstream configurations.
- **Stack:** Terraform >= 1.3; providers `hashicorp/google ~> 7.0` + `hashicorp/random`. Depends on
  one published module for the state bucket. Pin the provider and all module sources.
- **Layout:** Flat root module — `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`. No submodules.
- **Environments / backend:** None in this repo — it is a library module, not a deployment. It has no
  backend of its own; callers supply organisation, billing account, and region as inputs.
- **Consumers:** Referenced as a versioned registry module; treat inputs and outputs as a public API —
  changes are breaking until released under a new version.

## Working intelligence — before writing anything
- **Reuse first.** Search this repo (and the module registries it already uses) for existing code,
  modules, and patterns that solve or half-solve the task; prefer **extending** them over creating new.
  Name what you're building on, or state explicitly that nothing fits.
- **Read before you write.** Match the surrounding structure, naming, and idioms.
- **Proportional effort.** Smallest change that fully solves it; don't reinvent or gold-plate.

## Cloud infrastructure
- Least privilege by default — explicit, scoped IAM; no broad/primitive roles.
- Consistent resource naming + labels/tags (owner, environment, cost-centre) on every resource.
- Remote state, per-environment isolation; environments parameterised, never hardcoded.
- Prefer keyless / workload-identity auth over long-lived credentials.

## Terraform
- Clear module structure; typed variables, documented outputs.
- Pin provider and module versions; no floating `latest`.
- No secrets in code, variables, or state inputs — source them from a secrets manager.
- `plan` before `apply`; `apply`/`destroy` are deliberate, reviewed actions — never automatic.
- Reuse existing/published modules over bespoke ones; extend, don't fork-and-drift.

## Code quality
- Readable and consistent with the surrounding code; clarity over cleverness.
- Small, focused changes; one concern at a time.
- DRY — factor duplication into shared modules/locals/helpers.
- Validate: format + lint + the project's tests (for Terraform: `fmt`, `validate`, then `plan`).
- Comment only the non-obvious; no dead or commented-out code.

## Security
- Never commit secrets, credentials, or identifying data — keep them out of code, inputs, and logs (rotate if exposed).
- Least privilege everywhere; restrict network egress; follow CIS-style hardening.
- No side-effecting commands (cloud mutations, `apply`/`destroy`, `git push`) without explicit human approval.
- Treat generated changes as **drafts for human review**.
