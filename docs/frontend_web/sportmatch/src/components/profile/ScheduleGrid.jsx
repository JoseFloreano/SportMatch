export default function ScheduleGrid({ schedule }) {
  return (
    <div style={{ background: 'var(--mist)', borderRadius: 14, padding: 12, marginBottom: 16 }}>
      <div
        style={{
          fontSize: 10,
          fontWeight: 700,
          letterSpacing: '0.08em',
          textTransform: 'uppercase',
          color: 'var(--slate)',
          marginBottom: 10,
        }}
      >
        Horarios habituales
      </div>
      <div style={{ display: 'flex', gap: 6 }}>
        {schedule.days.map((d, i) => (
          <div
            key={i}
            style={{
              flex: 1,
              textAlign: 'center',
              padding: '8px 4px',
              borderRadius: 8,
              background: d.active ? 'var(--ink)' : 'transparent',
            }}
          >
            <div
              style={{
                fontSize: 9,
                fontWeight: 700,
                textTransform: 'uppercase',
                color: d.active ? 'rgba(255,255,255,0.5)' : 'var(--slate)',
                marginBottom: 4,
              }}
            >
              {d.code}
            </div>
            <div
              style={{
                width: 6,
                height: 6,
                borderRadius: '50%',
                background: d.active ? 'var(--volt)' : 'var(--border)',
                margin: '0 auto',
              }}
            />
          </div>
        ))}
      </div>
      {schedule.note && (
        <div style={{ marginTop: 8, fontSize: 12, color: 'var(--slate)' }}>{schedule.note}</div>
      )}
    </div>
  )
}
