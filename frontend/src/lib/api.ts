export type CatalogTemplate = {
  name: string
  service_type: 'GKE_CLUSTER' | 'VM' | 'CLOUD_SQL' | 'DATAPROC_CLUSTER' | 'DATAFLOW_JOB'
  terraform_module: string
  version: string
  inputs_schema: Record<string, unknown>
}

export type ProvisionRequest = {
  id: string
  template_name: string
  service_type: CatalogTemplate['service_type']
  environment: 'dev' | 'staging' | 'prod'
  status:
    | 'DRAFT'
    | 'PENDING_APPROVAL'
    | 'APPROVED'
    | 'REJECTED'
    | 'PROVISIONING'
    | 'ACTIVE'
    | 'FAILED'
  inputs: Record<string, unknown>
  approval_reason?: string | null
  last_error?: string | null
  created_at: string
  updated_at: string
  last_transition_at: string
}

const API_BASE = import.meta.env.VITE_API_BASE ?? 'http://localhost:8000/api'

async function http<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`${API_BASE}${path}`, {
    ...init,
    headers: {
      'content-type': 'application/json',
      ...(init?.headers ?? {}),
    },
  })
  if (!res.ok) {
    const text = await res.text().catch(() => '')
    throw new Error(`${res.status} ${res.statusText}${text ? `: ${text}` : ''}`)
  }
  return (await res.json()) as T
}

export const api = {
  healthz: () => http<{ status: string }>('/healthz'),
  listCatalogTemplates: () => http<CatalogTemplate[]>('/catalog/templates'),
  createProvisionRequest: (body: {
    template_name: string
    environment: 'dev' | 'staging' | 'prod'
    inputs: Record<string, unknown>
  }) =>
    http<ProvisionRequest>('/catalog/provision-requests', {
      method: 'POST',
      body: JSON.stringify(body),
    }),
  submitProvisionRequest: (requestId: string) =>
    http<ProvisionRequest>(`/catalog/provision-requests/${requestId}/submit`, { method: 'POST' }),
  approvalAction: (requestId: string, body: { action: 'APPROVE' | 'REJECT'; reason?: string }) =>
    http<ProvisionRequest>(`/catalog/provision-requests/${requestId}/approval`, {
      method: 'POST',
      body: JSON.stringify(body),
    }),
  triggerPipeline: (body: { pipeline_name: string; parameters: Record<string, string> }) =>
    http('/data/pipelines/trigger', { method: 'POST', body: JSON.stringify(body) }),
  listPipelineRuns: () => http('/data/pipelines/runs'),
}

