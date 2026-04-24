variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "Primary region"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/staging/prod)"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "nexusgrid"
}

variable "primary_cidr" {
  type        = string
  description = "Primary subnet CIDR"
  default     = "10.10.0.0/20"
}

