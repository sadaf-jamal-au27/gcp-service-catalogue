# NexusGrid — API Design (v1)

Base URL: `/api`

## Principles

- **Workflow-first**: requests move through approval + provisioning states.
- **Auditability**: every action is attributable (later: `actor`, `policy`, `ticket_id`).
- **Async by default**: long-running provisioning/pipelines are jobs with status and logs URL.

## Service Catalog

### List templates

- `GET /catalog/templates`
- Returns Terraform-backed templates shown in the catalog UI.

### Create provision request

- `POST /catalog/provision-requests`

Request:

```json
{
  "template_name": "gke-private-cluster",
  "environment": "dev",
  "inputs": {
    "cluster_name": "my-cluster",
    "region": "us-central1"
  }
}
```

### Submit for approval

- `POST /catalog/provision-requests/{id}/submit`
- Transition: `DRAFT` → `PENDING_APPROVAL`

### Approve / reject

- `POST /catalog/provision-requests/{id}/approval`

```json
{ "action": "APPROVE", "reason": "Change window approved" }
```

Transitions:

- `PENDING_APPROVAL` → `APPROVED`
- `PENDING_APPROVAL` → `REJECTED`

> Next iteration: `APPROVED` triggers a provisioning job (Cloud Build + Terraform apply) moving to `PROVISIONING` and then `ACTIVE/FAILED`.

## Data Engineering Hub

### Trigger pipeline

- `POST /data/pipelines/trigger`

```json
{
  "pipeline_name": "daily-bq-refresh",
  "parameters": { "date": "2026-04-24" }
}
```

### List pipeline runs

- `GET /data/pipelines/runs`

> Next iteration: surface `logs_url` for Cloud Logging, Dataflow job id, Dataproc job id.

## Microservices Hub (planned)

- `POST /microservices/deploy` (trigger build + deploy)
- `GET /microservices/services` (list services)
- `GET /microservices/services/{name}` (status, rollout, SLO link)

## Observability (planned)

- `GET /observability/dashboards`
- `GET /observability/alerts`
- `GET /observability/slo`

