// Level selector: 3 pills (rx red, scaled amber, beginner green).
const TONES = {
  rx:       { border: 'var(--red)',   bg: 'var(--red-light)'   },
  scaled:   { border: 'var(--amber)', bg: 'var(--amber-light)' },
  beginner: { border: 'var(--green)', bg: 'var(--green-light)' },
}

export default function LevelSelector({ levels, value, onChange }) {
  return (
    <div style={{ display: 'flex', gap: 8, marginBottom: 20 }}>
      {levels.map((lvl) => {
        const selected = value === lvl.id
        const t = TONES[lvl.tone] ?? {}
        return (
          <button
            key={lvl.id}
            type="button"
            onClick={() => onChange(lvl.id)}
            style={{
              flex: 1,
              border: selected ? `1.5px solid ${t.border}` : '1.5px solid var(--border)',
              background: selected ? t.bg : 'white',
              borderRadius: 10,
              padding: '8px 6px',
              textAlign: 'center',
              cursor: 'pointer',
              transition: 'all 0.15s',
            }}
          >
            <div className="font-display uppercase" style={{ fontSize: 14, fontWeight: 700, color: 'var(--ink)' }}>
              {lvl.name}
            </div>
            <div style={{ fontSize: 10, color: 'var(--slate)', marginTop: 2 }}>{lvl.desc}</div>
          </button>
        )
      })}
    </div>
  )
}
