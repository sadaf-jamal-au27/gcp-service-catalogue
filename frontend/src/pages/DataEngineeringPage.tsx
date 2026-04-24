import { Alert, Box, Button, Card, CardContent, Stack, Typography } from '@mui/material'
import { useState } from 'react'
import { api } from '../lib/api'

export function DataEngineeringPage() {
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  async function trigger() {
    setMessage(null)
    setError(null)
    try {
      const run = (await api.triggerPipeline({
        pipeline_name: 'daily-bq-refresh',
        parameters: { date: new Date().toISOString().slice(0, 10) },
      })) as { id: string; status: string }
      setMessage(`Triggered run ${run.id} (${run.status})`)
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : String(e))
    }
  }

  return (
    <Box>
      <Typography variant="h4" sx={{ mb: 2 }}>
        Data Engineering Hub
      </Typography>
      <Stack spacing={2}>
        {message && <Alert severity="success">{message}</Alert>}
        {error && <Alert severity="error">{error}</Alert>}
        <Card>
          <CardContent>
            <Typography variant="h6">ETL Pipelines</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
              Trigger Dataflow/Dataproc pipelines and track status (mocked locally).
            </Typography>
            <Button variant="contained" onClick={trigger}>
              Trigger daily-bq-refresh
            </Button>
          </CardContent>
        </Card>
      </Stack>
    </Box>
  )
}

