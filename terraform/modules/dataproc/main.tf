resource "google_service_account" "dataproc_vm" {
  project      = var.project_id
  account_id   = "${var.name_prefix}-${var.environment}-vm"
  display_name = "NexusGrid Dataproc VM SA (${var.environment})"
}

resource "google_project_iam_member" "dataproc_vm_worker" {
  project = var.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_service_account.dataproc_vm.email}"
}

resource "google_project_iam_member" "dataproc_vm_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.dataproc_vm.email}"
}

resource "google_project_iam_member" "dataproc_vm_metrics" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.dataproc_vm.email}"
}

resource "google_project_iam_member" "dataproc_vm_storage" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.dataproc_vm.email}"
}

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

      # Avoid relying on the default Compute Engine SA (often missing required Dataproc permissions).
      service_account = google_service_account.dataproc_vm.email
      service_account_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
    }

    master_config {
      num_instances = 1
      machine_type  = var.master_machine_type
      disk_config {
        boot_disk_type    = "pd-balanced"
        boot_disk_size_gb = var.master_boot_disk_gb
      }
    }

    worker_config {
      num_instances = var.worker_count
      machine_type  = var.worker_machine_type
      disk_config {
        boot_disk_type    = "pd-balanced"
        boot_disk_size_gb = var.worker_boot_disk_gb
      }
    }
  }
}

