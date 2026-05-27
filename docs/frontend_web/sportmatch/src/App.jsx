import { Route, Routes } from 'react-router-dom'
import MapPage         from './pages/MapPage.jsx'
import PublishPage     from './pages/PublishPage.jsx'
import EventDetailPage from './pages/EventDetailPage.jsx'
import ProfilePage     from './pages/ProfilePage.jsx'
import PlanPage        from './pages/PlanPage.jsx'
import PlaceholderPage from './pages/PlaceholderPage.jsx'

export default function App() {
  return (
    <Routes>
      <Route path="/"             element={<MapPage />} />
      <Route path="/publish"      element={<PublishPage />} />
      <Route path="/events"       element={<PlaceholderPage title="Eventos" description="Listado de eventos patrocinados de la zona — próximamente." />} />
      <Route path="/events/:id"   element={<EventDetailPage />} />
      <Route path="/chats"        element={<PlaceholderPage title="Chats" description="Tus conversaciones con asistentes y compañeros — próximamente." />} />
      <Route path="/profile"      element={<ProfilePage />} />
      <Route path="/plan"         element={<PlanPage />} />
      <Route path="*"             element={<PlaceholderPage title="404" description="Ruta no encontrada." />} />
    </Routes>
  )
}
