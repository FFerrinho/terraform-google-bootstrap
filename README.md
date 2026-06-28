# terraform-google-bootstrap

Terraform module that bootstraps the foundation needed to manage a Google Cloud environment with
Terraform. In a single apply it provisions a project (optionally inside a new folder), enables the
baseline APIs, creates a dedicated automation service account with impersonation wired up, and
stands up a versioned GCS bucket for remote state.

It is intended as the **first thing you run** against a fresh organization or folder, before any
workload Terraform. Authenticate as a privileged user (see [Prerequisites](#prerequisites)) for the
bootstrap apply; everything afterwards can run by impersonating the service account this module
creates — no exported keys.

## Features

- **Project creation** with a random numeric suffix appended to the display name, so the project ID
  is globally unique without manual bookkeeping.
- **Optional folder** — create a new folder for the project, nest it under an existing
  `parent_folder`, or place the project directly at the organization level.
- **Baseline APIs** enabled by default: `serviceusage.googleapis.com` and
  `cloudresourcemanager.googleapis.com`.
- **Automation service account** with configurable project roles (defaults to `roles/editor`) and a
  description, optionally created in a disabled state.
- **Impersonation, not keys** — grants chosen principals (`sa_users`) the roles needed to impersonate
  the service account (`roles/iam.serviceAccountUser` and `roles/iam.serviceAccountTokenCreator` by
  default).
- **Remote state bucket** — a versioned bucket with uniform bucket-level access, via the
  [`FFerrinho/bucket/google`](https://registry.terraform.io/modules/FFerrinho/bucket/google/latest)
  module, ready to host the state of everything you build next.
- **Mandatory labels** — `managed = "terraform"` and `purpose = "automation"` are merged onto the
  project on top of any `labels` you supply.

## Usage

```hcl
module "bootstrap" {
  source  = "FFerrinho/bootstrap/google"
  version = "~> 1.0"

  organization_id      = "123456789012"
  billing_account      = "012345-6789AB-CDEF01"
  region               = "europe-west1"
  project_display_name = "Platform Automation"

  # Folder placement (see "Folder placement" below)
  create_folder = true
  folder_name   = "platform"

  # Automation service account
  service_account_display_name = "terraform-automation"

  # Principals allowed to impersonate the service account
  sa_users = [
    "user:platform-admin@example.com",
    "group:platform-team@example.com",
  ]
}
```

### Folder placement

The project's location is driven by `create_folder`, `folder_name`, and `parent_folder`:

| `create_folder` | `parent_folder` | Result |
|---|---|---|
| `true`  | set     | A new folder `folder_name` is created **under** `parent_folder`; the project goes inside it. |
| `true`  | `null`  | A new folder `folder_name` is created at the **organization** level; the project goes inside it. |
| `false` | set     | The project is created inside the **existing** folder referenced by `parent_folder`. |
| `false` | `null`  | The project is created directly at the **organization** level. |

### Identifying the organization

Supply **either** `organization_id` **or** `organization_domain` — the module looks the organization
up from whichever you provide.

### Billing account

`billing_account` accepts either a billing account ID (format `XXXXXX-XXXXXX-XXXXXX`) or a billing
account display name; a display name is resolved to its ID via a data source.

## Prerequisites

The principal running the bootstrap apply needs organization- (or folder-) level permissions, since
the module creates projects, folders, and IAM bindings. At a minimum:

- `roles/resourcemanager.projectCreator` on the org or target folder
- `roles/resourcemanager.folderCreator` (only when `create_folder = true`)
- `roles/billing.user` on the billing account (to associate it with the new project)
- Permission to read the organization (`roles/resourcemanager.organizationViewer`)

## Reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | 7.38.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.9.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_tf_state_bucket"></a> [tf\_state\_bucket](#module\_tf\_state\_bucket) | FFerrinho/bucket/google | 1.0.2 |

## Resources

| Name | Type |
| ---- | ---- |
| [google_folder.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_project.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_iam_member.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [random_id.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_billing_account.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/billing_account) | data source |
| [google_folder.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/folder) | data source |
| [google_organization.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auto_create_network"></a> [auto\_create\_network](#input\_auto\_create\_network) | If the project should auto create a network. | `bool` | `false` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The billing account id. | `string` | n/a | yes |
| <a name="input_create_folder"></a> [create\_folder](#input\_create\_folder) | If a folder will be created along the bootstrap. | `bool` | `false` | no |
| <a name="input_folder_name"></a> [folder\_name](#input\_folder\_name) | The name for the folder. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Additional labels for the resources. | `map(string)` | `{}` | no |
| <a name="input_organization_domain"></a> [organization\_domain](#input\_organization\_domain) | The organization domain. | `string` | `null` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The organization id. | `string` | `null` | no |
| <a name="input_parent_folder"></a> [parent\_folder](#input\_parent\_folder) | The parent folder id. | `string` | `null` | no |
| <a name="input_project_deletion_policy"></a> [project\_deletion\_policy](#input\_project\_deletion\_policy) | The deletion policy for the project. | `string` | `"DELETE"` | no |
| <a name="input_project_display_name"></a> [project\_display\_name](#input\_project\_display\_name) | The project display name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create the resources. | `string` | n/a | yes |
| <a name="input_sa_member_roles"></a> [sa\_member\_roles](#input\_sa\_member\_roles) | SA roles to grant to users. | `set(string)` | <pre>[<br/>  "roles/iam.serviceAccountUser",<br/>  "roles/iam.serviceAccountTokenCreator"<br/>]</pre> | no |
| <a name="input_sa_users"></a> [sa\_users](#input\_sa\_users) | A list of users that will be able to impersonate de service account. | `set(string)` | n/a | yes |
| <a name="input_service_account_description"></a> [service\_account\_description](#input\_service\_account\_description) | The description for the service account. | `string` | `"Terraform SA for infrastructure automation."` | no |
| <a name="input_service_account_disabled"></a> [service\_account\_disabled](#input\_service\_account\_disabled) | If the service account should be disabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_service_account_display_name"></a> [service\_account\_display\_name](#input\_service\_account\_display\_name) | The display name for the service account. | `string` | n/a | yes |
| <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles) | A list of roles to grant to the service account. | `set(string)` | <pre>[<br/>  "roles/editor"<br/>]</pre> | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_folder_name"></a> [folder\_name](#output\_folder\_name) | The name fo the folder created or used in the bootstrap. |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The name of the project created. |
| <a name="output_sa_users"></a> [sa\_users](#output\_sa\_users) | The users that will impersonate the service account. |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | The service account created. |
| <a name="output_tf_state_bucket"></a> [tf\_state\_bucket](#output\_tf\_state\_bucket) | The name of the bucket created for the terraform state. |
<!-- END_TF_DOCS -->

## License

MIT — see [LICENSE](LICENSE).
