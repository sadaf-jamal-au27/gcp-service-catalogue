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

module "dataproc" {
  source      = "../../modules/dataproc"
  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  name_prefix          = var.dataproc_name_prefix
  network_self_link    = module.network.network_self_link
  subnetwork_self_link = module.network.subnetwork_self_link

  master_machine_type = var.master_machine_type
  worker_machine_type = var.worker_machine_type
  worker_count        = var.worker_count
}

