import {
  Alert,
  Box,
  Button,
  Card,
  CardActions,
  CardContent,
  CircularProgress,
  Grid,
  Stack,
  Typography,
} from '@mui/material'
import { useEffect, useState } from 'react'
import { api } from '../lib/api'
import type { CatalogTemplate, ProvisionRequest } from '../lib/api'

export function ServiceCatalogPage() {
  const [templates, setTemplates] = useState<CatalogTemplate[] | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [lastRequest, setLastRequest] = useState<ProvisionRequest | null>(null)

  useEffect(() => {
    let cancelled = false
    api
      .listCatalogTemplates()
      .then((t) => {
        if (!cancelled) setTemplates(t)
      })
      .catch((e: unknown) => {
        if (!cancelled) setError(e instanceof Error ? e.message : String(e))
      })
    return () => {
      cancelled = true
    }
  }, [])

  async function requestProvision(t: CatalogTemplate) {
    setError(null)
    setLastRequest(null)
    try {
      const pr = await api.createProvisionRequest({
        template_name: t.name,
        environment: 'dev',
        inputs: { cluster_name: `demo-${Date.now()}` },
      })
      const submitted = await api.submitProvisionRequest(pr.id)
      const approved = await api.approvalAction(submitted.id, { action: 'APPROVE', reason: 'dev auto-approve' })
      setLastRequest(approved)
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : String(e))
    }
  }

  return (
    <Box>
      <Typography variant="h4" sx={{ mb: 1 }}>
        Service Catalog
      </Typography>
      <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
        Backed by Terraform modules (mocked locally). Prod environments will require approval.
      </Typography>

      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}

      {lastRequest && (
        <Alert severity="success" sx={{ mb: 2 }}>
          Provision request <code>{lastRequest.id}</code> is now <b>{lastRequest.status}</b> for template{' '}
          <code>{lastRequest.template_name}</code>.
        </Alert>
      )}

      {!templates && !error && (
        <Stack direction="row" spacing={1} alignItems="center">
          <CircularProgress size={18} />
          <Typography variant="body2">Loading templates…</Typography>
        </Stack>
      )}

      {templates && (
        <Grid container spacing={2}>
          {templates.map((t) => (
            <Grid item key={t.name} xs={12} md={6} lg={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6" sx={{ mb: 0.5 }}>
                    {t.name}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Type: <code>{t.service_type}</code>
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Terraform: <code>{t.terraform_module}</code>
                  </Typography>
                </CardContent>
                <CardActions>
                  <Button size="small" onClick={() => requestProvision(t)}>
                    Request (dev)
                  </Button>
                </CardActions>
              </Card>
            </Grid>
          ))}
        </Grid>
      )}
    </Box>
  )
}

