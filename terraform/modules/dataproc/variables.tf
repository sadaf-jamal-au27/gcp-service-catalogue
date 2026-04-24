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

variable "disk_type" {
  type        = string
  description = "Boot disk type for Dataproc VMs (pd-standard|pd-balanced|pd-ssd)"
  default     = "pd-standard"
}

variable "master_boot_disk_gb" {
  type        = number
  description = "Master boot disk size (GB)"
  default     = 50
}

variable "worker_boot_disk_gb" {
  type        = number
  description = "Worker boot disk size (GB)"
  default     = 100
}

variable "create_vm_service_account" {
  type        = bool
  description = "Create a dedicated VM service account for Dataproc"
  default     = true
}

variable "vm_service_account_email" {
  type        = string
  description = "Use an existing VM service account email (when create_vm_service_account=false)"
  default     = ""
}

