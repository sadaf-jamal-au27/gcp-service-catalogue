locals {
  vm_service_account_email = var.create_vm_service_account ? google_service_account.dataproc_vm[0].email : var.vm_service_account_email
}

resource "google_service_account" "dataproc_vm" {
  count        = var.create_vm_service_account ? 1 : 0
  project      = var.project_id
  account_id   = "${var.name_prefix}-${var.environment}-vm"
  display_name = "NexusGrid Dataproc VM SA (${var.environment})"
}

# Minimum roles to satisfy Dataproc VM agent + logging/metrics + staging bucket access.
resource "google_project_iam_member" "dataproc_vm_worker" {
  count   = var.manage_project_iam ? 1 : 0
  project = var.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${local.vm_service_account_email}"
}

resource "google_project_iam_member" "dataproc_vm_log_writer" {
  count   = var.manage_project_iam ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${local.vm_service_account_email}"
}

resource "google_project_iam_member" "dataproc_vm_metric_writer" {
  count   = var.manage_project_iam ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${local.vm_service_account_email}"
}

resource "google_project_iam_member" "dataproc_vm_storage" {
  count   = var.manage_project_iam ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${local.vm_service_account_email}"
}

resource "google_dataproc_cluster" "primary" {
  name    = "${var.name_prefix}-${var.environment}"
  project = var.project_id
  region  = var.region

  cluster_config {
    gce_cluster_config {
      # Provider constraint: `network` conflicts with `subnetwork`.
      # Prefer `subnetwork` to ensure correct regional placement.
      subnetwork       = var.subnetwork_self_link
      internal_ip_only = true

      service_account = local.vm_service_account_email
      service_account_scopes = [
        "cloud-platform",
      ]
    }

    master_config {
      num_instances = 1
      machine_type  = var.master_machine_type
      disk_config {
        boot_disk_type    = var.disk_type
        boot_disk_size_gb = var.master_boot_disk_gb
      }
    }

    worker_config {
      num_instances = var.worker_count
      machine_type  = var.worker_machine_type
      disk_config {
        boot_disk_type    = var.disk_type
        boot_disk_size_gb = var.worker_boot_disk_gb
      }
    }
  }
}

