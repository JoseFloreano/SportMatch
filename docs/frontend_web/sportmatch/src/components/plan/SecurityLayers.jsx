import { securityLayers } from '../../data/mockData.js'

const TAG_TONES = {
  req: { background: 'var(--mist)',  color: 'var(--ink-mid)' },
  opt: { background: '#E0F7F5',      color: '#006B60' },
  new: { background: '#EBF9D4',      color: '#3A6B0A' },
}

export default function SecurityLayers() {
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
        gap: 16,
      }}
    >
      {securityLayers.map((layer) => {
        const primary = layer.primary
        return (
          <div
            key={layer.step}
            style={{
              position: 'relative',
              background: primary ? '#FAFFF0' : 'white',
              border: primary ? '1px solid var(--volt-dark)' : '1px solid var(--border)',
              borderRadius: 20,
              padding: 24,
              overflow: 'hidden',
              transition: 'border-color 0.2s, transform 0.15s',
            }}
          >
            {primary && (
              <span
                className="font-display uppercase"
                style={{
                  position: 'absolute',
                  top: 14,
                  right: 14,
                  fontSize: 10,
                  fontWeight: 700,
                  letterSpacing: '0.1em',
                  background: 'var(--volt)',
                  color: 'var(--ink)',
                  padding: '2px 8px',
                  borderRadius: 4,
                }}
              >
                Nuevo
              </span>
            )}
            <div
              className="font-display uppercase"
              style={{
                fontSize: 11,
                fontWeight: 700,
                letterSpacing: '0.1em',
                color: 'var(--slate)',
                marginBottom: 10,
                display: 'flex',
                alignItems: 'center',
                gap: 8,
              }}
            >
              <span
                style={{
                  width: 22,
                  height: 22,
                  borderRadius: '50%',
                  background: primary ? 'var(--volt)' : 'var(--mist)',
                  color: 'var(--ink)',
                  fontSize: 11,
                  fontWeight: 700,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                {layer.step}
              </span>
              {layer.label}
            </div>
            <div className="font-display uppercase" style={{ fontSize: 20, fontWeight: 700, color: 'var(--ink)', marginBottom: 8 }}>
              {layer.title}
            </div>
            <div style={{ fontSize: 13, color: 'var(--slate)', lineHeight: 1.6 }}>{layer.body}</div>
            <span
              style={{
                display: 'inline-flex',
                marginTop: 14,
                fontSize: 12,
                fontWeight: 500,
                padding: '4px 10px',
                borderRadius: 6,
                ...(TAG_TONES[layer.tagTone] ?? TAG_TONES.opt),
              }}
            >
              {layer.tag}
            </span>
          </div>
        )
      })}
    </div>
  )
}
