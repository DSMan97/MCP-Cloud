variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The default region for resources"
  type        = string
  default     = "us-central1"
}

variable "image_url" {
  description = "URL for the MCP container image"
  type        = string
}

variable "service_account_id" {
  description = "Service Account ID"
  type        = string
  default     = "gcp-mcp-server-sa"
}

variable "mcp_service_name" {
  description = "MCP service name"
  type        = string
  default     = "gcp-mcp-server"
}

variable "cloud_run_cpu" {
  description = "CPU limit for Cloud Run"
  type        = string
  default     = "1"
}

variable "cloud_run_memory" {
  description = "Memory limit for Cloud Run"
  type        = string
  default     = "512Mi"
}
