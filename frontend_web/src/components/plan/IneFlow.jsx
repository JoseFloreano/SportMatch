import { ineFlow, ineNotes } from '../../data/mockData.js'

const NOTE_TONES = {
  green: '#EBF9D4',
  amber: '#FEF6E7',
  teal:  '#E0F7F5',
  red:   '#FEF0F0',
}

export default function IneFlow() {
  return (
    <div
      style={{
        background: 'linear-gradient(135deg, #F0FFF4 0%, #FAFFF0 100%)',
        border: '1.5px solid #7DC63E',
        borderRadius: 28,
        padding: 32,
        marginBottom: 16,
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 24, flexWrap: 'wrap' }}>
        <span
          className="font-display uppercase"
          style={{
            background: 'var(--ink)',
            color: 'var(--volt)',
            fontSize: 13,
            fontWeight: 700,
            letterSpacing: '0.08em',
            padding: '6px 14px',
            borderRadius: 8,
          }}
        >
          INE / CURP
        </span>
        <div>
          <div className="font-display uppercase" style={{ fontSize: 22, fontWeight: 800, color: 'var(--ink)' }}>
            Flujo de verificación de identidad oficial
          </div>
          <div style={{ fontSize: 14, color: 'var(--slate)', marginTop: 2 }}>
            Integración con el padrón electoral del INE — sin almacenar datos sensibles
          </div>
        </div>
      </div>

      <div style={{ display: 'flex', alignItems: 'stretch', flexWrap: 'wrap', gap: 8 }}>
        {ineFlow.map((step, i) => (
          <div key={step.num} style={{ display: 'flex', alignItems: 'stretch', flex: '1 1 160px', gap: 8 }}>
            <div style={{ flex: 1, padding: 16, background: 'white', borderRadius: 12 }}>
              <div className="font-display" style={{ fontSize: 32, fontWeight: 800, color: 'var(--volt-dark)', lineHeight: 1, marginBottom: 6 }}>
                {step.num}
              </div>
              <div className="font-display uppercase" style={{ fontSize: 14, fontWeight: 700, color: 'var(--ink)', marginBottom: 4 }}>
                {step.label}
              </div>
              <div style={{ fontSize: 12, color: 'var(--slate)', lineHeight: 1.5 }}>{step.body}</div>
            </div>
            {i < ineFlow.length - 1 && (
              <div style={{ display: 'flex', alignItems: 'center', color: 'var(--volt-dark)', fontSize: 20, fontWeight: 300 }}>→</div>
            )}
          </div>
        ))}
      </div>

      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
          gap: 12,
          marginTop: 20,
        }}
      >
        {ineNotes.map((n, i) => (
          <div
            key={i}
            style={{
              background: 'white',
              borderRadius: 10,
              padding: '14px 16px',
              display: 'flex',
              gap: 10,
              alignItems: 'flex-start',
              border: '1px solid rgba(125,198,62,0.3)',
            }}
          >
            <span
              style={{
                width: 28,
                height: 28,
                borderRadius: 8,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 14,
                flexShrink: 0,
                background: NOTE_TONES[n.tone] ?? '#EBF9D4',
              }}
            >
              {n.icon}
            </span>
            <div>
              <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--ink)', marginBottom: 2 }}>{n.title}</div>
              <div style={{ fontSize: 12, color: 'var(--slate)', lineHeight: 1.5 }}>{n.body}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
