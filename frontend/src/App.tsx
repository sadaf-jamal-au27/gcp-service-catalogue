import { CssBaseline } from '@mui/material'
import { Navigate, Route, Routes } from 'react-router-dom'
import { AppLayout } from './components/AppLayout'
import { DashboardPage } from './pages/DashboardPage'
import { ServiceCatalogPage } from './pages/ServiceCatalogPage'
import { DataEngineeringPage } from './pages/DataEngineeringPage'
import { MicroservicesPage } from './pages/MicroservicesPage'
import { ObservabilityPage } from './pages/ObservabilityPage'
import { IamAccessPage } from './pages/IamAccessPage'

export default function App() {
  return (
    <>
      <CssBaseline />
      <Routes>
        <Route element={<AppLayout />}>
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/catalog" element={<ServiceCatalogPage />} />
          <Route path="/data" element={<DataEngineeringPage />} />
          <Route path="/microservices" element={<MicroservicesPage />} />
          <Route path="/observability" element={<ObservabilityPage />} />
          <Route path="/iam" element={<IamAccessPage />} />
        </Route>
      </Routes>
    </>
  )
}
