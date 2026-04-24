import { Box, Card, CardContent, Typography } from '@mui/material'

export function ObservabilityPage() {
  return (
    <Box>
      <Typography variant="h4" sx={{ mb: 2 }}>
        Observability
      </Typography>
      <Card>
        <CardContent>
          <Typography variant="body2" color="text.secondary">
            This page will embed Cloud Monitoring dashboards, log explorer views, alert policies, and SLOs. For local
            dev, we’ll stub these and later connect via Google APIs (with IAP/IAM).
          </Typography>
        </CardContent>
      </Card>
    </Box>
  )
}

