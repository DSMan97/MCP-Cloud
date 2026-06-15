variable "project_id" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy Cloud Run"
  type        = string
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "image_url" {
  description = "Container image URL (to be used for deployment)"
  type        = string
}

variable "service_account_email" {
  description = "Service Account email for Cloud Run"
  type        = string
}

variable "cpu" {
  description = "CPU limit for Cloud Run"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory limit for Cloud Run"
  type        = string
  default     = "512Mi"
}
