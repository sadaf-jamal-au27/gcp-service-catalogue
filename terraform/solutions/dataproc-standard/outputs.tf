output "network_self_link" {
  value       = module.network.network_self_link
  description = "VPC self link"
}

output "subnetwork_self_link" {
  value       = module.network.subnetwork_self_link
  description = "Subnet self link"
}

output "dataproc_cluster_name" {
  value       = module.dataproc.cluster_name
  description = "Dataproc cluster name"
}

output "dataproc_region" {
  value       = module.dataproc.region
  description = "Dataproc region"
}

