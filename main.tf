locals {
  folder_id = var.create_folder ? google_folder.main["folder"].id : data.google_folder.main.id
}

data "google_organization" "main" {
  organization = var.organization_id
  domain       = var.organization_domain
}

# If var.create_folder and var.folder_name are not specified, the project will be created at the organization level.
resource "google_folder" "main" {
  for_each     = toset(var.create_folder ? ["folder"] : [])
  display_name = var.folder_name
  # If a parent folder is specified, it'll create this folder bellow, otherwise it'll create at organization level.
  parent = var.parent_folder == null ? data.google_organization.main.id : var.parent_folder
}

data "google_folder" "main" {
  folder     = var.folder_name
  depends_on = [google_folder.main]
}

resource "random_id" "main" {
  byte_length = 2
}

resource "google_project" "main" {
  name                = var.project_display_name
  project_id          = join("-", [replace(var.project_display_name, " ", "-"), random_id.main.dec])
  org_id              = var.folder_name == "" ? data.google_organization.main.id : null
  folder_id           = var.folder_name != "" ? local.folder_id : null
  auto_create_network = var.auto_create_network

  labels = merge(
    var.labels,
    {
      managed = "terraform"
      purpose = "automation"
    }
  )
}

resource "google_service_account" "main" {
  account_id   = replace(var.service_account_display_name, " ", "-")
  display_name = var.service_account_display_name
  description  = var.service_account_description
  disabled     = var.service_account_disabled
  project      = google_project.main.project_id

  lifecycle {
    postcondition {
      condition     = can(regex("^[a-zA-Z]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\\.[a-zA-Z]([a-zA-Z0-9-]*[a-zA-Z0-9])?)*$", self.account_id))
      error_message = "The service account can only contains the characters comprehended in [a-z]([-a-z0-9]*[a-z0-9])."
    }
  }
}

resource "google_project_iam_member" "main" {
  for_each = toset(var.service_account_roles)
  project  = google_project.main.project_id
  role     = each.key
  member   = join(":", ["serviceAccount", google_service_account.main.email])
}

# This will grant individual users,groups or service accounts, permissions to impersonate the SA created in this bootstrap execution.
resource "google_service_account_iam_binding" "main" {
  for_each           = toset(var.sa_member_roles)
  service_account_id = google_service_account.main.id
  members            = var.sa_users
  role               = each.value
}

module "tf_state_bucket" {
  source  = "FFerrinho/bucket/google"
  version = "1.0.1"


  name       = "tf-state"
  location   = var.region
  project    = google_project.main.project_id
  versioning = true
  labels = {
    purpose = "state"
  }
}
