import DashboardIcon from '@mui/icons-material/Dashboard'
import LockIcon from '@mui/icons-material/Lock'
import MonitorHeartIcon from '@mui/icons-material/MonitorHeart'
import StorageIcon from '@mui/icons-material/Storage'
import TocIcon from '@mui/icons-material/Toc'
import {
  AppBar,
  Box,
  Divider,
  Drawer,
  List,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Toolbar,
  Typography,
} from '@mui/material'
import { Outlet, useLocation, useNavigate } from 'react-router-dom'

const drawerWidth = 260

const navItems: Array<{
  label: string
  path: string
  icon: React.ReactNode
}> = [
  { label: 'Dashboard', path: '/dashboard', icon: <DashboardIcon /> },
  { label: 'Service Catalog', path: '/catalog', icon: <TocIcon /> },
  { label: 'Data Engineering Hub', path: '/data', icon: <StorageIcon /> },
  { label: 'Microservices Hub', path: '/microservices', icon: <StorageIcon /> },
  { label: 'Observability', path: '/observability', icon: <MonitorHeartIcon /> },
  { label: 'IAM & Access', path: '/iam', icon: <LockIcon /> },
]

export function AppLayout() {
  const navigate = useNavigate()
  const location = useLocation()

  return (
    <Box sx={{ display: 'flex', minHeight: '100vh' }}>
      <AppBar position="fixed" sx={{ zIndex: (t) => t.zIndex.drawer + 1 }}>
        <Toolbar>
          <Typography variant="h6" noWrap>
            NexusGrid
          </Typography>
          <Box sx={{ flex: 1 }} />
          <Typography variant="body2" sx={{ opacity: 0.85 }}>
            Internal Developer Platform (dev)
          </Typography>
        </Toolbar>
      </AppBar>

      <Drawer
        variant="permanent"
        sx={{
          width: drawerWidth,
          flexShrink: 0,
          [`& .MuiDrawer-paper`]: { width: drawerWidth, boxSizing: 'border-box' },
        }}
      >
        <Toolbar />
        <Box sx={{ overflow: 'auto' }}>
          <List>
            {navItems.map((item) => (
              <ListItemButton
                key={item.path}
                selected={location.pathname === item.path}
                onClick={() => navigate(item.path)}
              >
                <ListItemIcon>{item.icon}</ListItemIcon>
                <ListItemText primary={item.label} />
              </ListItemButton>
            ))}
          </List>
          <Divider />
          <Box sx={{ px: 2, py: 2, color: 'text.secondary', typography: 'caption' }}>
            API expected at <code>http://localhost:8000/api</code>
          </Box>
        </Box>
      </Drawer>

      <Box component="main" sx={{ flexGrow: 1, p: 3 }}>
        <Toolbar />
        <Outlet />
      </Box>
    </Box>
  )
}

