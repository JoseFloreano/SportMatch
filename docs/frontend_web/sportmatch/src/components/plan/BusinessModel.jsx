import { businessMetrics } from '../../data/mockData.js'

export default function BusinessModel() {
  return (
    <div
      style={{
        background: 'var(--ink)',
        borderRadius: 28,
        padding: 32,
        marginBottom: 20,
        display: 'flex',
        gap: 32,
        alignItems: 'center',
        flexWrap: 'wrap',
      }}
    >
      <div style={{ flex: 1, minWidth: 260 }}>
        <h3 className="font-display uppercase" style={{ fontSize: 28, fontWeight: 800, color: 'white', marginBottom: 8, lineHeight: 1.05 }}>
          ¿Cómo gana
          <br />
          dinero <span style={{ color: 'var(--volt)' }}>SportMatch?</span>
        </h3>
        <p style={{ fontSize: 14, color: 'rgba(255,255,255,0.55)', lineHeight: 1.65, maxWidth: 480 }}>
          Modelo híbrido: ingresos B2B de establecimientos deportivos + ingresos B2C de usuarios (freemium + plan Pro) + eventos patrocinados. El foso competitivo está en la comunidad local activa, no en la tecnología.
        </p>
      </div>
      <div style={{ display: 'flex', gap: 20, flexWrap: 'wrap' }}>
        {businessMetrics.map((m, i) => (
          <div key={i} style={{ textAlign: 'center', minWidth: 90 }}>
            <div className="font-display" style={{ fontSize: 30, fontWeight: 800, color: 'var(--volt)', lineHeight: 1 }}>
              {m.val}
            </div>
            <div style={{ fontSize: 11, color: 'rgba(255,255,255,0.4)', marginTop: 4, fontWeight: 500 }}>{m.label}</div>
          </div>
        ))}
      </div>
    </div>
  )
}
