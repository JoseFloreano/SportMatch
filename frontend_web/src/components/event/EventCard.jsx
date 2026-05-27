// Small event summary card used inside the plan and listings.
export default function EventCard({ event, onClick }) {
  return (
    <div
      onClick={onClick}
      style={{
        background: 'var(--amber-light)',
        border: '1.5px solid var(--amber)',
        borderRadius: 16,
        padding: 14,
        cursor: onClick ? 'pointer' : 'default',
        display: 'flex',
        gap: 12,
      }}
    >
      <div
        style={{
          width: 48,
          height: 48,
          background: 'var(--ink)',
          borderRadius: 12,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: 22,
          flexShrink: 0,
        }}
      >
        {event.gym?.logo ?? '🏆'}
      </div>
      <div>
        <div
          className="font-display uppercase"
          style={{ fontSize: 16, fontWeight: 800, color: 'var(--ink)', lineHeight: 1.1, marginBottom: 4 }}
        >
          {event.title}
        </div>
        <div style={{ fontSize: 12, color: 'var(--slate)' }}>
          {event.date} · {event.time} · {event.location}
        </div>
      </div>
    </div>
  )
}
