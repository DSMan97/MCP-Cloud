output "mcp_service_url" {
  description = "The MCP service URL on Cloud Run"
  value       = module.cloud_run.service_url
}

output "mcp_service_account" {
  description = "The email of the Service Account used"
  value       = module.iam.service_account_email
}
