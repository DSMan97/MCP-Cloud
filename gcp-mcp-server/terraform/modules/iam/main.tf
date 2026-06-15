resource "google_service_account" "mcp_sa" {
  account_id   = var.service_account_id
  display_name = "MCP Server Service Account"
}

resource "google_project_iam_member" "logging_viewer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.mcp_sa.email}"
}

resource "google_project_iam_member" "storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.mcp_sa.email}"
}

resource "google_project_iam_member" "run_viewer" {
  project = var.project_id
  role    = "roles/run.viewer"
  member  = "serviceAccount:${google_service_account.mcp_sa.email}"
}

resource "google_project_iam_member" "cloudbuild_viewer" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.viewer"
  member  = "serviceAccount:${google_service_account.mcp_sa.email}"
}
