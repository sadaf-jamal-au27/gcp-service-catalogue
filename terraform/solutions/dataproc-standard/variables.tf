variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "Dataproc region"
  default     = "us-central1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/staging/prod)"
  default     = "dev"
}

variable "network_name_prefix" {
  type        = string
  description = "Prefix for VPC resources"
  default     = "nexusgrid"
}

variable "primary_cidr" {
  type        = string
  description = "Subnet CIDR"
  default     = "10.10.0.0/20"
}

variable "dataproc_name_prefix" {
  type        = string
  description = "Prefix for Dataproc cluster name"
  default     = "nexusgrid-dp"
}

variable "master_machine_type" {
  type        = string
  description = "Dataproc master machine type"
  default     = "e2-standard-4"
}

variable "worker_machine_type" {
  type        = string
  description = "Dataproc worker machine type"
  default     = "e2-standard-4"
}

variable "worker_count" {
  type        = number
  description = "Number of workers"
  default     = 2
}

