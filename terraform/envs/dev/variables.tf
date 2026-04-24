variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "Primary region"
  default     = "us-central1"
}

variable "tf_state_bucket" {
  type        = string
  description = "GCS bucket for Terraform state (used by Cloud Build)"
}

