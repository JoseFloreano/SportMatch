import { useNavigate, useParams } from 'react-router-dom'
import AppShell from '../components/AppShell.jsx'
import EventDetail from '../components/event/EventDetail.jsx'
import { events } from '../data/mockData.js'

export default function EventDetailPage() {
  const navigate = useNavigate()
  const { id } = useParams()

  const event = events.find((e) => e.id === id) ?? events[0]

  if (!event) {
    return (
      <AppShell hideTabs>
        <div style={{ padding: 24 }}>
          <p style={{ fontSize: 14, color: 'var(--slate)' }}>Evento no encontrado.</p>
          <button
            onClick={() => navigate('/')}
            style={{ marginTop: 16, padding: '8px 16px', background: 'var(--ink)', color: 'var(--volt)', border: 'none', borderRadius: 8, cursor: 'pointer' }}
          >
            Volver al mapa
          </button>
        </div>
      </AppShell>
    )
  }

  return (
    <AppShell hideTabs>
      <EventDetail
        event={event}
        onBack={() => navigate('/')}
        onRegister={() => alert('Inscripción enviada (mock)')}
        onChat={() => alert('Abriendo chat del evento (mock)')}
      />
    </AppShell>
  )
}
