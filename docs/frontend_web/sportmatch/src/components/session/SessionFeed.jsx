import { useNavigate } from 'react-router-dom'
import SessionCard from './SessionCard.jsx'

export default function SessionFeed({ sessions, title }) {
  const navigate = useNavigate()

  const handleAction = (s) => {
    if (s.isEvent) navigate(`/events/${s.id}`)
  }

  return (
    <div style={{ padding: '0 16px 16px' }}>
      <div
        className="font-display uppercase"
        style={{
          fontSize: 14,
          fontWeight: 700,
          color: 'var(--slate)',
          letterSpacing: '0.06em',
          marginBottom: 10,
          paddingTop: 4,
        }}
      >
        {title ?? `Cerca de ti · ${sessions.length} sesiones`}
      </div>
      {sessions.map((s) => (
        <SessionCard key={s.id} session={s} onAction={() => handleAction(s)} />
      ))}
      {sessions.length === 0 && (
        <div style={{ padding: '20px 0', fontSize: 13, color: 'var(--slate)', textAlign: 'center' }}>
          No hay sesiones para este filtro todavía.
        </div>
      )}
    </div>
  )
}
