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
  environment = "dev"
}

module "gke" {
  source      = "../../modules/gke"
  project_id  = var.project_id
  region      = var.region
  environment = "dev"

  network_self_link    = module.network.network_self_link
  subnetwork_self_link = module.network.subnetwork_self_link
}

module "dataproc" {
  source      = "../../modules/dataproc"
  project_id  = var.project_id
  region      = var.region
  environment = "dev"

  network_self_link    = module.network.network_self_link
  subnetwork_self_link = module.network.subnetwork_self_link
}

