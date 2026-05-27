const BADGE_TONES = {
  b2b:   { background: 'var(--ink)',          color: 'var(--volt)' },
  event: { background: 'var(--amber-light)',  color: '#7A4100' },
  free:  { background: 'var(--teal-light)',   color: '#005A52' },
  pro:   { background: '#F0EAFF',             color: '#4A1D96' },
}

const CARD_TONES = {
  b2b:    { border: 'rgba(14,17,23,0.25)', header: 'var(--ink)',         title: 'white',     est: 'var(--volt)', dot: 'var(--volt-dark)' },
  events: { border: 'var(--amber)',        header: 'var(--amber-light)', title: 'var(--ink)',est: 'var(--slate)',dot: 'var(--amber)' },
  free:   { border: 'var(--teal)',         header: 'var(--teal-light)',  title: 'var(--ink)',est: 'var(--slate)',dot: 'var(--teal)' },
  pro:    { border: '#9B6DFF',             header: '#F0EAFF',             title: 'var(--ink)',est: 'var(--slate)',dot: '#9B6DFF' },
}

export default function RevenueStream({ stream }) {
  const b = BADGE_TONES[stream.badgeTone] ?? BADGE_TONES.b2b
  const c = CARD_TONES[stream.cardTone]  ?? CARD_TONES.b2b
  return (
    <div style={{ borderRadius: 20, overflow: 'hidden', border: `1px solid ${c.border}` }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '20px 24px', background: c.header, flexWrap: 'wrap' }}>
        <span
          className="font-display uppercase"
          style={{
            background: b.background,
            color: b.color,
            fontSize: 11,
            fontWeight: 700,
            letterSpacing: '0.1em',
            padding: '4px 12px',
            borderRadius: 5,
            flexShrink: 0,
          }}
        >
          {stream.badge}
        </span>
        <div className="font-display uppercase" style={{ fontSize: 20, fontWeight: 700, color: c.title, flex: 1, minWidth: 200 }}>
          {stream.title}
        </div>
        <div style={{ fontSize: 13, fontWeight: 600, color: c.est, whiteSpace: 'nowrap' }}>{stream.estimate}</div>
      </div>

      <div style={{ padding: '0 24px 20px' }}>
        <p style={{ fontSize: 14, color: 'var(--slate)', lineHeight: 1.65, margin: '14px 0' }}>{stream.description}</p>

        {stream.example && (
          <div
            style={{
              background: 'white',
              border: '1.5px solid var(--amber)',
              borderRadius: 20,
              padding: '22px 24px',
              margin: '16px 0 14px',
              display: 'flex',
              gap: 20,
              alignItems: 'flex-start',
              flexWrap: 'wrap',
            }}
          >
            <div
              style={{
                width: 64,
                height: 64,
                borderRadius: 12,
                background: 'var(--ink)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 28,
                flexShrink: 0,
              }}
            >
              {stream.example.thumb}
            </div>
            <div style={{ flex: 1, minWidth: 200 }}>
              <div
                className="font-display uppercase"
                style={{ fontSize: 10, fontWeight: 700, letterSpacing: '0.12em', color: 'var(--amber)', marginBottom: 4 }}
              >
                {stream.example.label}
              </div>
              <div className="font-display uppercase" style={{ fontSize: 18, fontWeight: 800, color: 'var(--ink)', marginBottom: 6 }}>
                {stream.example.title}
              </div>
              <div style={{ fontSize: 13, color: 'var(--slate)', lineHeight: 1.6 }}>{stream.example.desc}</div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginTop: 10 }}>
                {stream.example.tags.map((t, i) => (
                  <span
                    key={i}
                    style={{
                      fontSize: 11,
                      fontWeight: 500,
                      padding: '3px 9px',
                      borderRadius: 5,
                      background: 'var(--amber-light)',
                      color: '#7A4100',
                    }}
                  >
                    {t}
                  </span>
                ))}
              </div>
            </div>
          </div>
        )}

        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {stream.items.map((item, i) => (
            <span
              key={i}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: 6,
                fontSize: 12,
                color: 'var(--ink-mid)',
                background: 'var(--mist)',
                borderRadius: 6,
                padding: '5px 11px',
              }}
            >
              <span style={{ width: 6, height: 6, borderRadius: '50%', background: c.dot }} />
              {item}
            </span>
          ))}
        </div>
      </div>
    </div>
  )
}
