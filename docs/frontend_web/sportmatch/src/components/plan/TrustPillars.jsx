import { trustPillars } from '../../data/mockData.js'

const ICON_TONES = {
  teal:  'var(--teal-light)',
  green: 'var(--green-light)',
  amber: 'var(--amber-light)',
  ink:   '#E8E9EF',
}

export default function TrustPillars() {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: 16 }}>
      {trustPillars.map((p, i) => (
        <div
          key={i}
          style={{
            background: 'var(--mist)',
            borderRadius: 20,
            padding: 24,
            border: '1px solid transparent',
          }}
        >
          <div
            style={{
              width: 40,
              height: 40,
              borderRadius: 10,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              marginBottom: 14,
              fontSize: 18,
              background: ICON_TONES[p.tone] ?? 'var(--mist)',
            }}
          >
            {p.icon}
          </div>
          <div className="font-display uppercase" style={{ fontSize: 17, fontWeight: 700, color: 'var(--ink)', marginBottom: 8 }}>
            {p.title}
          </div>
          <div style={{ fontSize: 13, color: 'var(--slate)', lineHeight: 1.65 }}>{p.body}</div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginTop: 12 }}>
            {p.tags.map((tag, j) => (
              <span
                key={j}
                style={{
                  fontSize: 11,
                  fontWeight: 500,
                  padding: '3px 9px',
                  borderRadius: 5,
                  border: '1px solid var(--border)',
                  color: 'var(--ink-mid)',
                  background: 'white',
                }}
              >
                {tag}
              </span>
            ))}
          </div>
        </div>
      ))}
    </div>
  )
}
