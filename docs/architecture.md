# NexusGrid — Production Architecture (GCP)

## High-level architecture diagram

```mermaid
flowchart LR
  user[Developer / Data Engineer] -->|HTTPS + SSO| iap[Cloud IAP]
  iap --> lb[External HTTPS Load Balancer]
  lb --> portal[Portal UI (Cloud Run or GKE Ingress)]
  portal --> api[NexusGrid API (Cloud Run or GKE)]

  api --> sm[Secret Manager]
  api --> sql[(Cloud SQL - Postgres)]
  api --> bq[(BigQuery)]
  api --> gcs[(Cloud Storage)]
  api --> pubsub[(Pub/Sub)]

  api --> cb[Cloud Build]
  cb --> ar[Artifact Registry]
  cb --> gke[GKE Private Cluster]

  api --> mon[Cloud Monitoring]
  api --> log[Cloud Logging]

  subgraph vpc[Hub-and-Spoke VPC]
    hub[Hub VPC]
    spoke1[Spoke: GKE]
    spoke2[Spoke: Data / Analytics]
    hub --- spoke1
    hub --- spoke2
    hub --- psc[Private Service Connect]
  end

  gke --- vpc
  sql --- psc
  bq --- psc
```

## Key GCP building blocks (what + why)

- **Identity-Aware Proxy (IAP)**: central SSO gate for the portal; reduces attack surface.
- **External HTTPS Load Balancer**: TLS termination + Cloud Armor policies.
- **Portal UI**: served via **Cloud Run** (simpler) or **GKE** (if you want single platform).
- **NexusGrid API**: orchestrates workflows (approval, provisioning, audit); calls GCP APIs using service accounts.
- **Cloud SQL (Postgres)**: authoritative store for catalog items, requests, approvals, pipeline metadata.
- **Pub/Sub**: eventing between modules (provision-request approved → provisioning started).
- **Cloud Build**: CI/CD and “infra provisioning runners” (Terraform apply inside locked-down pipeline).
- **Secret Manager**: all credentials + tokens; no secrets in repo.
- **Cloud Monitoring/Logging**: portal health, SLOs, alerting, audit logs.
- **Cloud Armor**: WAF + IP allowlists for corp networks (if needed).

## Networking & security posture

- **Hub-and-spoke**: hub for shared services (egress, DNS, inspection); spokes for GKE and data.
- **Private networking**: no public IPs on nodes/workers; private Google access + PSC for managed services.
- **Least privilege**: separate service accounts for “portal”, “provisioner”, “pipeline-trigger”.
- **VPC Service Controls**: perimeter around data services (BigQuery, GCS) for exfiltration protection.
- **HTTPS everywhere**: enforced at the LB; internal mTLS can be added later (Istio optional).

## Deployment target recommendation (pragmatic)

- Start with **Cloud Run** for `frontend` + `backend` to ship fast.
- Move API + microservices control-plane into **GKE** only if you need:
  - advanced networking (multi-cluster, mesh)
  - large internal plugin ecosystem
  - co-locating controllers/operators

