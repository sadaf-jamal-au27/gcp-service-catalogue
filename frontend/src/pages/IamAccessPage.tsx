import { Box, Card, CardContent, Typography } from '@mui/material'

export function IamAccessPage() {
  return (
    <Box>
      <Typography variant="h4" sx={{ mb: 2 }}>
        IAM & Access Control
      </Typography>
      <Card>
        <CardContent>
          <Typography variant="body2" color="text.secondary">
            Target model:
            <br />
            - Admin, Dev, Data Engineer roles
            <br />
            - Google IAM / Identity Federation for authN/authZ
            <br />
            - IAP for portal access + least-privilege service accounts for provisioning
          </Typography>
        </CardContent>
      </Card>
    </Box>
  )
}

