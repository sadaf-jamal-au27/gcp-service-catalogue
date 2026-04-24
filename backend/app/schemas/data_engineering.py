from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field

from .common import BaseResource


PipelineStatus = Literal["QUEUED", "RUNNING", "SUCCEEDED", "FAILED", "CANCELLED"]


class PipelineTriggerRequest(BaseModel):
    pipeline_name: str
    parameters: dict[str, str] = Field(default_factory=dict)


class PipelineRun(BaseResource):
    pipeline_name: str
    status: PipelineStatus
    parameters: dict[str, str]
    started_at: datetime | None = None
    finished_at: datetime | None = None
    logs_url: str | None = None
