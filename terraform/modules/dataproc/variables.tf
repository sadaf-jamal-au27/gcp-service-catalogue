variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "Dataproc region"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/staging/prod)"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "nexusgrid-dp"
}

variable "network_self_link" {
  type        = string
  description = "VPC self_link"
}

variable "subnetwork_self_link" {
  type        = string
  description = "Subnet self_link"
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

variable "master_boot_disk_gb" {
  type        = number
  description = "Master boot disk size (GB). Keep small to avoid SSD_TOTAL_GB quota issues."
  default     = 50
}

variable "worker_boot_disk_gb" {
  type        = number
  description = "Worker boot disk size (GB). Keep small to avoid SSD_TOTAL_GB quota issues."
  default     = 100
}

