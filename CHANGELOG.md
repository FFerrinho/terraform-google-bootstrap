# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this module adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-06-28

### Changed

- **BREAKING:** Upgraded the `hashicorp/google` provider constraint from `6.5.0` to `~> 7.0`. Review
  the [provider v7 upgrade guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/version_7_upgrade)
  before adopting.
- Pinned a minimum Terraform core version of `>= 1.3`.
- Set `disable_on_destroy = true` explicitly on `google_project_service.main` to preserve the
  pre-7.0 behaviour (provider 7.0 changed the default from `true` to `false`).

### Removed

- **BREAKING:** Removed the `service_account_id` input variable. It was required but never used — the
  service account's `account_id` is derived from `service_account_display_name`. Remove it from any
  module call; passing it now raises an "unsupported argument" error.

### Added

- Authored `README.md` content (description, features, usage, folder-placement matrix, prerequisites)
  and a `.terraform-docs.yml` to pin the generated reference block.

[2.0.0]: https://github.com/FFerrinho/terraform-google-bootstrap/compare/1.2.3...2.0.0
[1.2.3]: https://github.com/FFerrinho/terraform-google-bootstrap/releases/tag/1.2.3
