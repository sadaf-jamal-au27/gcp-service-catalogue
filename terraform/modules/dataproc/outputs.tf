output "cluster_name" {
  value = google_dataproc_cluster.primary.name
}

output "region" {
  value = google_dataproc_cluster.primary.region
}

output "vm_service_account_email" {
  value = local.vm_service_account_email
}

