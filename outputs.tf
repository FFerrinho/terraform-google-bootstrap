output "folder_name" {
  description = "The name fo the folder created or used in the bootstrap."
  value       = google_folder.main["folder"].name == "" ? data.google_folder.main.display_name : google_folder.main["folder"].display_name
}

output "project_name" {
  description = "The name of the project created."
  value       = google_project.main.name  
}

output "service_account" {
  description = "The service account created."
  value       = google_service_account.main.email
}

output "sa_users" {
  description = "The users that will impersonate the service account."
  value       = var.sa_users
}

output "tf_state_bucket" {
  description = "The name of the bucket created for the terraform state."
  value       = module.tf_state_bucket.name
}
