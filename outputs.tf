output "folder_name" {
  description = "The name fo the folder created or used in the bootstrap."
  value       = google_folder.main["folder"].name == "" ? data.google_folder.main.name : google_folder.main["folder"].name
}
