import { Alert, Box, Card, CardContent, Grid, Typography } from '@mui/material'
import { useEffect, useMemo, useState } from 'react'
import { api } from '../lib/api'

export function DashboardPage() {
  const [apiStatus, setApiStatus] = useState<'unknown' | 'ok' | 'error'>('unknown')
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let cancelled = false
    api
      .healthz()
      .then(() => {
        if (!cancelled) setApiStatus('ok')
      })
      .catch((e: unknown) => {
        if (!cancelled) {
          setApiStatus('error')
          setError(e instanceof Error ? e.message : String(e))
        }
      })
    return () => {
      cancelled = true
    }
  }, [])

  const headline = useMemo(() => {
    if (apiStatus === 'ok') return 'API connected'
    if (apiStatus === 'error') return 'API not reachable'
    return 'Checking API...'
  }, [apiStatus])

  return (
    <Box>
      <Typography variant="h4" sx={{ mb: 2 }}>
        Dashboard
      </Typography>

      {apiStatus !== 'ok' && (
        <Alert severity={apiStatus === 'error' ? 'error' : 'info'} sx={{ mb: 2 }}>
          {headline}
          {error ? ` — ${error}` : ''}
        </Alert>
      )}

      <Grid container spacing={2}>
        <Grid item xs={12} md={6} lg={3}>
          <Card>
            <CardContent>
              <Typography variant="overline">Active clusters</Typography>
              <Typography variant="h5">2</Typography>
              <Typography variant="body2" color="text.secondary">
                (placeholder: GKE + Dataproc)
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={6} lg={3}>
          <Card>
            <CardContent>
              <Typography variant="overline">Alerts</Typography>
              <Typography variant="h5">0</Typography>
              <Typography variant="body2" color="text.secondary">
                (placeholder)
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={6} lg={3}>
          <Card>
            <CardContent>
              <Typography variant="overline">Cost today</Typography>
              <Typography variant="h5">$—</Typography>
              <Typography variant="body2" color="text.secondary">
                (FinOps module later)
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} md={6} lg={3}>
          <Card>
            <CardContent>
              <Typography variant="overline">Platform health</Typography>
              <Typography variant="h5">{apiStatus === 'ok' ? 'Healthy' : 'Degraded'}</Typography>
              <Typography variant="body2" color="text.secondary">
                backend: {apiStatus}
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  )
}

