variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "service_account_id" {
  description = "ID for the MCP Service Account"
  type        = string
  default     = "gcp-mcp-server-sa"
}
