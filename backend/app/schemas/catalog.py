from datetime import datetime
from typing import Any, Literal

from pydantic import BaseModel, Field

from .common import ApprovalStatus, BaseResource


ServiceType = Literal["GKE_CLUSTER", "VM", "CLOUD_SQL", "DATAPROC_CLUSTER", "DATAFLOW_JOB"]


class CatalogTemplate(BaseModel):
    name: str
    service_type: ServiceType
    terraform_module: str = Field(..., description="Terraform module path (e.g. modules/gke)")
    version: str = "v1"
    inputs_schema: dict[str, Any] = Field(
        default_factory=dict,
        description="JSON-schema-like description of expected inputs",
    )


class ProvisionRequestCreate(BaseModel):
    template_name: str
    environment: Literal["dev", "staging", "prod"] = "dev"
    inputs: dict[str, Any] = Field(default_factory=dict)


class ProvisionRequest(BaseResource):
    template_name: str
    service_type: ServiceType
    environment: Literal["dev", "staging", "prod"]
    status: ApprovalStatus
    inputs: dict[str, Any]
    approval_reason: str | None = None
    last_error: str | None = None
    last_transition_at: datetime


class ApprovalAction(BaseModel):
    action: Literal["APPROVE", "REJECT"]
    reason: str | None = None
