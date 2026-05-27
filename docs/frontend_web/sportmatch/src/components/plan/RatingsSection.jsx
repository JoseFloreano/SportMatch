import { ratingCriteria } from '../../data/mockData.js'

export default function RatingsSection() {
  return (
    <div style={{ background: 'var(--ink)', borderRadius: 28, padding: '36px 32px', color: 'white' }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 16, marginBottom: 24, flexWrap: 'wrap' }}>
        <h3 className="font-display uppercase" style={{ fontSize: 24, fontWeight: 800, color: 'white' }}>
          Qué se califica — y por qué importa
        </h3>
        <p style={{ fontSize: 14, color: 'rgba(255,255,255,0.5)' }}>Aparece 2 horas después de la sesión</p>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: 14 }}>
        {ratingCriteria.map((c, i) => (
          <div
            key={i}
            style={{
              background: 'rgba(255,255,255,0.06)',
              border: '1px solid rgba(255,255,255,0.1)',
              borderRadius: 14,
              padding: 18,
            }}
          >
            <div style={{ color: 'var(--volt)', fontSize: 16, marginBottom: 8, letterSpacing: 2 }}>★★★★★</div>
            <div className="font-display uppercase" style={{ fontSize: 14, fontWeight: 700, color: 'rgba(255,255,255,0.9)', marginBottom: 4 }}>
              {c.label}
            </div>
            <div style={{ fontSize: 12, color: 'rgba(255,255,255,0.5)', lineHeight: 1.5 }}>{c.body}</div>
          </div>
        ))}
      </div>

      <div
        style={{
          marginTop: 20,
          background: 'rgba(232,57,58,0.15)',
          border: '1px solid rgba(232,57,58,0.3)',
          borderRadius: 10,
          padding: '14px 18px',
          fontSize: 13,
          color: '#FF9B9B',
          display: 'flex',
          gap: 10,
          alignItems: 'center',
        }}
      >
        <span style={{ fontSize: 18 }}>⚠️</span>
        <span>Usuario con rating &lt; 3.5 en "Respeto y trato" después de 5+ sesiones → suspensión automática pendiente de revisión. Sin excepciones.</span>
      </div>
    </div>
  )
}
