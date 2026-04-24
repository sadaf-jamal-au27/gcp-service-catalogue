from __future__ import annotations

from fastapi import APIRouter, HTTPException

from ..schemas.catalog import (
    ApprovalAction,
    ProvisionRequest,
    ProvisionRequestCreate,
)
from ..schemas.data_engineering import PipelineRun, PipelineTriggerRequest
from ..services.store import store

router = APIRouter()


@router.get("/healthz")
def healthz() -> dict[str, str]:
    return {"status": "ok"}


@router.get("/catalog/templates")
def list_catalog_templates():
    return store.list_templates()


@router.post("/catalog/provision-requests", response_model=ProvisionRequest)
def create_provision_request(req: ProvisionRequestCreate):
    try:
        pr = store.create_provision_request(req)
    except KeyError as e:
        raise HTTPException(status_code=404, detail=str(e)) from e
    return pr


@router.get("/catalog/provision-requests/{request_id}", response_model=ProvisionRequest)
def get_provision_request(request_id: str):
    try:
        return store.get_provision_request(request_id)
    except KeyError as e:
        raise HTTPException(status_code=404, detail="Not found") from e


@router.post("/catalog/provision-requests/{request_id}/submit", response_model=ProvisionRequest)
def submit_provision_request(request_id: str):
    try:
        pr = store.get_provision_request(request_id)
    except KeyError as e:
        raise HTTPException(status_code=404, detail="Not found") from e

    if pr.status != "DRAFT":
        raise HTTPException(status_code=409, detail=f"Invalid transition from {pr.status}")

    return store.transition_provision_request(request_id, "PENDING_APPROVAL")


@router.post("/catalog/provision-requests/{request_id}/approval", response_model=ProvisionRequest)
def approval_action(request_id: str, body: ApprovalAction):
    try:
        pr = store.get_provision_request(request_id)
    except KeyError as e:
        raise HTTPException(status_code=404, detail="Not found") from e

    if pr.status != "PENDING_APPROVAL":
        raise HTTPException(status_code=409, detail=f"Invalid transition from {pr.status}")

    if body.action == "APPROVE":
        return store.transition_provision_request(request_id, "APPROVED", approval_reason=body.reason)
    return store.transition_provision_request(request_id, "REJECTED", approval_reason=body.reason)


@router.post("/data/pipelines/trigger", response_model=PipelineRun)
def trigger_pipeline(req: PipelineTriggerRequest):
    run = store.trigger_pipeline(req)
    # Minimal state change to simulate execution.
    store.pipeline_runs[run.id] = run.model_copy(
        update={"status": "RUNNING", "started_at": run.created_at, "updated_at": run.created_at}
    )
    return store.pipeline_runs[run.id]


@router.get("/data/pipelines/runs", response_model=list[PipelineRun])
def list_pipeline_runs():
    return store.list_pipeline_runs()
