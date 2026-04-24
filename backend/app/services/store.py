from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any
from uuid import uuid4

from ..schemas.catalog import CatalogTemplate, ProvisionRequest, ProvisionRequestCreate
from ..schemas.common import ApprovalStatus
from ..schemas.data_engineering import PipelineRun, PipelineTriggerRequest


def _now() -> datetime:
    return datetime.now(tz=timezone.utc)


@dataclass
class InMemoryStore:
    templates: dict[str, CatalogTemplate]
    provision_requests: dict[str, ProvisionRequest]
    pipeline_runs: dict[str, PipelineRun]

    @staticmethod
    def bootstrap() -> "InMemoryStore":
        templates = {
            "gke-private-cluster": CatalogTemplate(
                name="gke-private-cluster",
                service_type="GKE_CLUSTER",
                terraform_module="modules/gke",
                inputs_schema={
                    "cluster_name": {"type": "string", "required": True},
                    "region": {"type": "string", "default": "us-central1"},
                    "node_count": {"type": "number", "default": 3},
                },
            ),
            "dataproc-standard": CatalogTemplate(
                name="dataproc-standard",
                service_type="DATAPROC_CLUSTER",
                terraform_module="modules/dataproc",
                inputs_schema={
                    "cluster_name": {"type": "string", "required": True},
                    "region": {"type": "string", "default": "us-central1"},
                },
            ),
        }
        return InMemoryStore(templates=templates, provision_requests={}, pipeline_runs={})

    def list_templates(self) -> list[CatalogTemplate]:
        return list(self.templates.values())

    def create_provision_request(self, req: ProvisionRequestCreate) -> ProvisionRequest:
        if req.template_name not in self.templates:
            raise KeyError(f"Unknown template: {req.template_name}")

        template = self.templates[req.template_name]
        rid = str(uuid4())
        now = _now()
        pr = ProvisionRequest(
            id=rid,
            created_at=now,
            updated_at=now,
            template_name=req.template_name,
            service_type=template.service_type,
            environment=req.environment,
            status="DRAFT",
            inputs=req.inputs,
            last_transition_at=now,
        )
        self.provision_requests[rid] = pr
        return pr

    def get_provision_request(self, request_id: str) -> ProvisionRequest:
        return self.provision_requests[request_id]

    def transition_provision_request(
        self,
        request_id: str,
        new_status: ApprovalStatus,
        *,
        approval_reason: str | None = None,
        last_error: str | None = None,
    ) -> ProvisionRequest:
        pr = self.get_provision_request(request_id)
        now = _now()
        updated = pr.model_copy(
            update={
                "status": new_status,
                "updated_at": now,
                "last_transition_at": now,
                "approval_reason": approval_reason if approval_reason is not None else pr.approval_reason,
                "last_error": last_error,
            }
        )
        self.provision_requests[request_id] = updated
        return updated

    def trigger_pipeline(self, req: PipelineTriggerRequest) -> PipelineRun:
        rid = str(uuid4())
        now = _now()
        run = PipelineRun(
            id=rid,
            created_at=now,
            updated_at=now,
            pipeline_name=req.pipeline_name,
            status="QUEUED",
            parameters=req.parameters,
            started_at=None,
            finished_at=None,
            logs_url=None,
        )
        self.pipeline_runs[rid] = run
        return run

    def list_pipeline_runs(self) -> list[PipelineRun]:
        return sorted(self.pipeline_runs.values(), key=lambda r: r.created_at, reverse=True)


store = InMemoryStore.bootstrap()
