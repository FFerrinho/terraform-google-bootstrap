variable "organization_id" {
  description = "The organization id."
  type        = string
  default     = null
}

variable "organization_domain" {
  description = "The organization domain."
  type        = string
  default     = null
}

variable "billing_account" {
  description = "The billing account id."
  type        = string
}

variable "create_folder" {
  description = "If a folder will be created along the bootstrap."
  type        = bool
}

variable "folder_name" {
  description = "The name for the folder."
  type        = string
  default     = null
}

variable "parent_folder" {
  description = "The parent folder id."
  type        = string
  default     = null
}

variable "project_display_name" {
  description = "The project display name."
  type        = string
}

variable "auto_create_network" {
  description = "If the project should auto create a network."
  type        = bool
  default     = false
}

variable "project_deletion_policy" {
  description = "The deletion policy for the project."
  type        = string
  default     = "DELETE"
}

variable "labels" {
  description = "Additional labels for the resources."
  type        = map(string)
  default     = {}
}

variable "service_account_id" {
  description = "The service account id."
  type        = string
}

variable "service_account_display_name" {
  description = "The display name for the service account."
  type        = string

  validation {
    condition     = length(var.service_account_display_name) >= 6 && length(var.service_account_display_name) <= 30
    error_message = "Service account display name must be between 6 and 30 characters long."
  }
}

variable "service_account_description" {
  description = "The description for the service account."
  type        = string
  default     = "Terraform SA for infrastructure automation."

  validation {
    condition     = length(var.service_account_description) <= 256
    error_message = "The description must be under 256 characters."
  }
}

variable "service_account_disabled" {
  description = "If the service account should be disabled. Defaults to false."
  type        = bool
  default     = false
}

variable "service_account_roles" {
  description = "A list of roles to grant to the service account."
  type        = set(string)
  default     = ["roles/editor"]
}

variable "sa_member_roles" {
  description = "SA roles to grant to users."
  type        = set(string)
  default     = ["roles/iam.serviceAccountUser", "roles/iam.serviceAccountTokenCreator"]
}

variable "sa_users" {
  description = "A list of users that will be able to impersonate de service account."
  type        = set(string)

  validation {
    #condition     = can(regex("^(user:|group:|serviceAccount:).+", var.sa_users))
    condition     = can(regex("^(user:|group:|serviceAccount:).+", join(",", var.sa_users)))
    error_message = "IAM user must be prefixed with 'user:', 'group:', or 'serviceAccount:'"
  }
}

variable "region" {
  description = "The region to create the resources."
  type        = string
}
