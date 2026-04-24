# NexusGrid (Internal Developer Platform)

NexusGrid is a production-minded **enterprise internal developer portal** for Google Cloud:

- **Service Catalog**: self-service infrastructure (Terraform-backed) + approval workflow
- **Data Engineering Hub**: pipelines / Dataproc / Dataflow / BigQuery controls
- **Microservices Hub**: GKE deployments + CI/CD integration
- **Observability**: Monitoring/Logging dashboards + SLOs
- **IAM & Access**: RBAC + Google identity integration (IAP / federation)

## Repo layout

- `frontend/`: React (Vite) portal UI
- `backend/`: FastAPI service (API + workflow primitives)
- `terraform/`: module-based Terraform (network, GKE, Dataproc)
- `docs/`: architecture + API design

## Run locally (dev)

Backend:

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

Frontend:

```bash
cd frontend
npm install
npm run dev
```

Open the portal at `http://localhost:5173`.

## Docs

- `docs/architecture.md`
- `docs/api.md`

# gcp-service-catalogue (NexusGrid)

Enterprise-style internal portal starter for a **Service Catalogue** on GCP.

## Structure

- `apps/web`: Next.js portal (UI)
- `apps/api`: Platform API (later split into domain services)
- `packages/shared`: shared types/validators

## Prereqs

- Node.js 20+ (you have Node 22)
- npm 9+

## Run (after scaffolding completes)

```bash
npm install
npm run dev:web
```

In a second terminal:

```bash
npm run dev:api
```

# gcp-service-catalogue-project
