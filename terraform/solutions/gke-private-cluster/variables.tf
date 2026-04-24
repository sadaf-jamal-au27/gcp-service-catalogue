variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "Primary region"
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

variable "cluster_name_prefix" {
  type        = string
  description = "Prefix for GKE cluster name"
  default     = "nexusgrid-gke"
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

