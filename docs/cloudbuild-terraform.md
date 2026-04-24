# Cloud Build CI/CD for Terraform (dev plan → master apply)

## Goal

- On `dev` branch: `terraform init` + `terraform plan`
- On `master` branch: `terraform init` + `terraform plan` + `terraform apply`

Cloud Build runs Terraform inside a locked-down service account and uses a **GCS backend** for state.

## Files

- `cloudbuild/terraform-dev-plan.yaml`
- `cloudbuild/terraform-master-apply.yaml`
- `terraform/envs/dev/backend.tf` (declares `backend "gcs" {}`)

## One-time setup

### 1) Create a state bucket

Create a bucket (example):

- `gs://<YOUR_TF_STATE_BUCKET>`

Recommended settings:

- uniform bucket-level access
- versioning enabled

### 2) Grant Cloud Build permissions

Grant the Cloud Build SA permissions (minimum depends on resources). Common:

- **State bucket**: Storage Object Admin (or narrower)
- **Provisioning**: permissions for VPC/GKE/Dataproc (start broad; then least-privilege)

Cloud Build service account:

- `<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com`

### 3) Create Cloud Build triggers (GitHub)

Create two triggers in Cloud Build → Triggers:

#### Trigger A: `dev` plan

- **Event**: push to branch
- **Branch**: `^dev$`
- **Config**: `cloudbuild/terraform-dev-plan.yaml`
- **Substitutions**:
  - `_TF_STATE_BUCKET=<YOUR_TF_STATE_BUCKET>`
  - `_TF_STATE_PREFIX=nexusgrid/dev`

#### Trigger B: `master` apply

- **Event**: push to branch
- **Branch**: `^master$`
- **Config**: `cloudbuild/terraform-master-apply.yaml`
- **Substitutions**:
  - `_TF_STATE_BUCKET=<YOUR_TF_STATE_BUCKET>`
  - `_TF_STATE_PREFIX=nexusgrid/dev`

Recommended: enable **manual approval** on the master trigger (so apply is gated).

## Notes / assumptions

- Both builds currently use `terraform/envs/dev` as the root.
- `project_id` is set to `$PROJECT_ID` in Cloud Build.
- Region default is `us-central1` (adjust in YAML or pass substitution/vars).

