## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 6.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tf_state_bucket"></a> [tf\_state\_bucket](#module\_tf\_state\_bucket) | ../terraform-google-bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [google_folder.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/resources/folder) | resource |
| [google_project.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/resources/project) | resource |
| [google_project_iam_member.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/resources/project_iam_member) | resource |
| [google_project_service.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/resources/project_service) | resource |
| [google_service_account.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/resources/service_account_iam_binding) | resource |
| [random_id.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_billing_account.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/data-sources/billing_account) | data source |
| [google_folder.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/data-sources/folder) | data source |
| [google_organization.main](https://registry.terraform.io/providers/hashicorp/google/6.5.0/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_network"></a> [auto\_create\_network](#input\_auto\_create\_network) | If the project should auto create a network. | `bool` | `false` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The billing account id. | `string` | n/a | yes |
| <a name="input_create_folder"></a> [create\_folder](#input\_create\_folder) | If a folder will be created along the bootstrap. | `bool` | n/a | yes |
| <a name="input_folder_name"></a> [folder\_name](#input\_folder\_name) | The name for the folder. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Additional labels for the resources. | `map(string)` | `{}` | no |
| <a name="input_organization_domain"></a> [organization\_domain](#input\_organization\_domain) | The organization domain. | `string` | `null` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The organization id. | `string` | `null` | no |
| <a name="input_parent_folder"></a> [parent\_folder](#input\_parent\_folder) | The parent folder id. | `string` | `null` | no |
| <a name="input_project_deletion_policy"></a> [project\_deletion\_policy](#input\_project\_deletion\_policy) | The deletion policy for the project. | `string` | `"DELETE"` | no |
| <a name="input_project_display_name"></a> [project\_display\_name](#input\_project\_display\_name) | The project display name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create the resources. | `string` | n/a | yes |
| <a name="input_sa_member_roles"></a> [sa\_member\_roles](#input\_sa\_member\_roles) | SA roles to grant to users. | `set(string)` | <pre>[<br>  "roles/iam.serviceAccountUser",<br>  "roles/iam.serviceAccountTokenCreator"<br>]</pre> | no |
| <a name="input_sa_users"></a> [sa\_users](#input\_sa\_users) | A list of users that will be able to impersonate de service account. | `set(string)` | n/a | yes |
| <a name="input_service_account_description"></a> [service\_account\_description](#input\_service\_account\_description) | The description for the service account. | `string` | `"Terraform SA for infrastructure automation."` | no |
| <a name="input_service_account_disabled"></a> [service\_account\_disabled](#input\_service\_account\_disabled) | If the service account should be disabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_service_account_display_name"></a> [service\_account\_display\_name](#input\_service\_account\_display\_name) | The display name for the service account. | `string` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | The service account id. | `string` | n/a | yes |
| <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles) | A list of roles to grant to the service account. | `set(string)` | <pre>[<br>  "roles/editor"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_folder_name"></a> [folder\_name](#output\_folder\_name) | The name fo the folder created or used in the bootstrap. |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The name of the project created. |
