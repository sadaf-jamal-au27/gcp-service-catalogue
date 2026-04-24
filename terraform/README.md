# NexusGrid Terraform

This folder contains a **module-based** Terraform layout for NexusGrid.

## Structure

- `solutions/`: **Service Catalog-ready** root modules (one solution per catalog item)
- `modules/network`: hub-and-spoke VPC baseline (placeholders)
- `modules/gke`: private GKE cluster (placeholders)
- `modules/dataproc`: Dataproc cluster (placeholders)
- `envs/dev`: example environment wiring

## Run (dev example)

```bash
cd terraform/envs/dev
terraform init
terraform plan
```

> Note: Modules are intentionally minimal right now. Next iteration will add full hub-spoke, NCC, private access,
> and opinionated firewall/IAM.

