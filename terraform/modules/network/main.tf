resource "google_compute_network" "vpc" {
  name                    = "${var.name_prefix}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "primary" {
  name          = "${var.name_prefix}-subnet"
  project       = var.project_id
  region        = var.region
  ip_cidr_range = var.primary_cidr
  network       = google_compute_network.vpc.id

  private_ip_google_access = true
}

