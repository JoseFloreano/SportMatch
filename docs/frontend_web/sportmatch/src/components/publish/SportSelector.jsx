// 3x2 grid sport picker. Single select.
export default function SportSelector({ sports, value, onChange }) {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginBottom: 20 }}>
      {sports.map((s) => {
        const selected = value === s.id
        return (
          <button
            key={s.id}
            type="button"
            onClick={() => onChange(s.id)}
            style={{
              border: selected ? '1.5px solid var(--ink)' : '1.5px solid var(--border)',
              background: selected ? 'var(--ink)' : 'white',
              borderRadius: 12,
              padding: '10px 6px',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              gap: 4,
              cursor: 'pointer',
              transition: 'all 0.15s',
            }}
          >
            <span style={{ fontSize: 22 }}>{s.emoji}</span>
            <span
              className="font-display uppercase"
              style={{
                fontSize: 12,
                fontWeight: 700,
                color: selected ? 'var(--volt)' : 'var(--ink)',
              }}
            >
              {s.label}
            </span>
          </button>
        )
      })}
    </div>
  )
}
