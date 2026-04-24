import { Box, Card, CardContent, Typography } from '@mui/material'

export function MicroservicesPage() {
  return (
    <Box>
      <Typography variant="h4" sx={{ mb: 2 }}>
        Microservices Hub
      </Typography>
      <Card>
        <CardContent>
          <Typography variant="body1" sx={{ mb: 1 }}>
            Coming next
          </Typography>
          <Typography variant="body2" color="text.secondary">
            - Deploy services to GKE (Cloud Build / GitHub Actions triggers)
            <br />- Optional Istio service mesh visibility
            <br />- API Gateway / Apigee integration
          </Typography>
        </CardContent>
      </Card>
    </Box>
  )
}

