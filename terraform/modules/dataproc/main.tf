resource "google_dataproc_cluster" "primary" {
  name    = "${var.name_prefix}-${var.environment}"
  project = var.project_id
  region  = var.region

  cluster_config {
    gce_cluster_config {
      # Provider v7 expects `network` / `subnetwork` (name or self_link).
      # Dataproc provider schema treats these as conflicting; prefer subnetwork.
      subnetwork       = var.subnetwork_self_link
      internal_ip_only = true
    }

    master_config {
      num_instances = 1
      machine_type  = var.master_machine_type
      disk_config {
        boot_disk_type    = "pd-balanced"
        boot_disk_size_gb = 100
      }
    }

    worker_config {
      num_instances = var.worker_count
      machine_type  = var.worker_machine_type
      disk_config {
        boot_disk_type    = "pd-balanced"
        boot_disk_size_gb = 200
      }
    }
  }
}

