import { nichoSports } from '../../data/mockData.js'

export default function NichoBlock() {
  return (
    <div
      style={{
        background: 'linear-gradient(135deg, #F0FFF4 0%, #F5FFEB 100%)',
        border: '1.5px solid var(--volt-dark)',
        borderRadius: 28,
        padding: '28px 32px',
        marginTop: 20,
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 20, flexWrap: 'wrap' }}>
        <span
          className="font-display uppercase"
          style={{
            background: 'var(--ink)',
            color: 'var(--volt)',
            fontSize: 12,
            fontWeight: 700,
            letterSpacing: '0.08em',
            padding: '5px 14px',
            borderRadius: 8,
          }}
        >
          Enfoque año 1
        </span>
        <span className="font-display uppercase" style={{ fontSize: 22, fontWeight: 800, color: 'var(--ink)' }}>
          ¿Por qué deporte funcional primero?
        </span>
      </div>
      <p style={{ fontSize: 14, color: 'var(--slate)', lineHeight: 1.65, marginBottom: 20 }}>
        El deporte funcional (CrossFit, calistenia, HIIT, kettlebell) tiene la comunidad más activa en CDMX, la mayor densidad de boxes y studios en Condesa/Roma/Polanco, y los usuarios más comprometidos en términos de frecuencia (3–5 sesiones por semana). Es el nicho con mayor disposición a pagar, mayor facilidad para el matching por nivel, y donde el "no show" duele más — lo que hace que la propuesta de valor de SportMatch sea más clara y urgente.
      </p>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(160px, 1fr))',
          gap: 12,
        }}
      >
        {nichoSports.map((n, i) => (
          <div
            key={i}
            style={{
              background: 'white',
              borderRadius: 12,
              padding: 16,
              border: '1px solid rgba(157,202,0,0.3)',
              textAlign: 'center',
            }}
          >
            <div style={{ fontSize: 24, marginBottom: 8 }}>{n.emoji}</div>
            <div className="font-display uppercase" style={{ fontSize: 15, fontWeight: 700, color: 'var(--ink)', marginBottom: 4 }}>
              {n.title}
            </div>
            <div style={{ fontSize: 12, color: 'var(--slate)', lineHeight: 1.5 }}>{n.body}</div>
          </div>
        ))}
      </div>
      <div
        style={{
          marginTop: 16,
          padding: '14px 18px',
          background: 'white',
          borderRadius: 10,
          border: '1px solid rgba(157,202,0,0.4)',
          fontSize: 13,
          color: 'var(--slate)',
        }}
      >
        <strong style={{ color: 'var(--ink)' }}>Expansión futura:</strong> Una vez consolidado el nicho funcional con matching confiable en 2–3 zonas de CDMX, expandir a running, tenis, yoga y fútbol. El modelo de matching por nivel es el mismo — solo cambian los filtros.
      </div>
    </div>
  )
}
