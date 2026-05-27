// Three pills (RX / Scaled / Beginner) with spots available.
const TONES = {
  rx: { border: 'var(--red)',   bg: 'var(--red-light)',   spots: '#8B1A1A' },
  sc: { border: 'var(--amber)', bg: 'var(--amber-light)', spots: '#7A4100' },
  bg: { border: 'var(--green)', bg: 'var(--green-light)', spots: '#1A6B3E' },
}

export default function LevelAvailability({ availability }) {
  return (
    <div style={{ display: 'flex', gap: 8, marginBottom: 14 }}>
      {availability.map((lvl) => {
        const t = TONES[lvl.tone] ?? TONES.bg
        return (
          <div
            key={lvl.level}
            style={{
              flex: 1,
              border: `1.5px solid ${t.border}`,
              background: t.bg,
              borderRadius: 12,
              padding: 10,
              textAlign: 'center',
            }}
          >
            <div className="font-display uppercase" style={{ fontSize: 14, fontWeight: 700, color: 'var(--ink)' }}>
              {lvl.level}
            </div>
            <div style={{ fontSize: 11, marginTop: 3, color: t.spots }}>{lvl.spots}</div>
          </div>
        )
      })}
    </div>
  )
}
