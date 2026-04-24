variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "Region (or zone) for the cluster"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/staging/prod)"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "nexusgrid-gke"
}

variable "network_self_link" {
  type        = string
  description = "VPC self_link"
}

variable "subnetwork_self_link" {
  type        = string
  description = "Subnet self_link"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Private control plane CIDR"
  default     = "172.16.0.0/28"
}

variable "pods_cidr" {
  type        = string
  description = "Pod CIDR"
  default     = "10.20.0.0/16"
}

variable "services_cidr" {
  type        = string
  description = "Service CIDR"
  default     = "10.30.0.0/20"
}

variable "node_count" {
  type        = number
  description = "Node count"
  default     = 3
}

variable "node_machine_type" {
  type        = string
  description = "Node machine type"
  default     = "e2-standard-4"
}

variable "node_locations" {
  type        = list(string)
  description = "Optional list of zones for the node pool (helps control quota usage for regional clusters)"
  default     = []
}

