output "network_self_link" {
  value       = module.network.network_self_link
  description = "VPC self link"
}

output "subnetwork_self_link" {
  value       = module.network.subnetwork_self_link
  description = "Subnet self link"
}

output "cluster_name" {
  value       = module.gke.cluster_name
  description = "GKE cluster name"
}

output "cluster_location" {
  value       = module.gke.location
  description = "GKE location"
}

