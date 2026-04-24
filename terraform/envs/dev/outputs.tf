output "network" {
  value = {
    network_self_link    = module.network.network_self_link
    subnetwork_self_link = module.network.subnetwork_self_link
  }
}

output "gke" {
  value = {
    cluster_name = module.gke.cluster_name
    location     = module.gke.location
  }
}

output "dataproc" {
  value = {
    cluster_name = module.dataproc.cluster_name
    region       = module.dataproc.region
  }
}

