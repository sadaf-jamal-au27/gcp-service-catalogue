from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field


ApprovalStatus = Literal["DRAFT", "PENDING_APPROVAL", "APPROVED", "REJECTED", "PROVISIONING", "ACTIVE", "FAILED"]


class BaseResource(BaseModel):
    id: str = Field(..., description="Stable resource identifier")
    created_at: datetime
    updated_at: datetime
