terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source      = "../../modules/network"
  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  name_prefix  = var.network_name_prefix
  primary_cidr = var.primary_cidr
}

module "gke" {
  source      = "../../modules/gke"
  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  name_prefix            = var.cluster_name_prefix
  network_self_link      = module.network.network_self_link
  subnetwork_self_link   = module.network.subnetwork_self_link
  node_count             = var.node_count
  node_machine_type      = var.node_machine_type
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  pods_cidr              = var.pods_cidr
  services_cidr          = var.services_cidr
}

