export default function SportPrefs({ prefs }) {
  return (
    <div style={{ marginBottom: 16 }}>
      <div
        style={{
          fontSize: 11,
          fontWeight: 700,
          letterSpacing: '0.08em',
          textTransform: 'uppercase',
          color: 'var(--slate)',
          marginBottom: 8,
        }}
      >
        Deportes
      </div>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
        {prefs.map((p, i) => (
          <span
            key={i}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 6,
              fontSize: 12,
              fontWeight: 600,
              padding: '6px 12px',
              borderRadius: 8,
              border: p.primary ? '1.5px solid var(--ink)' : '1.5px solid var(--border)',
              background: p.primary ? 'var(--ink)' : 'white',
              color: p.primary ? 'var(--volt)' : 'var(--ink)',
            }}
          >
            <span>{p.emoji}</span>
            {p.label}
          </span>
        ))}
      </div>
    </div>
  )
}
