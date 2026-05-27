export default function WomenMode() {
  return (
    <div
      style={{
        background: 'linear-gradient(135deg, #FDF0F8 0%, #F8F0FF 100%)',
        border: '1.5px solid #DDA0D8',
        borderRadius: 28,
        padding: '28px 32px',
        display: 'flex',
        gap: 24,
        alignItems: 'flex-start',
        flexWrap: 'wrap',
      }}
    >
      <div
        style={{
          width: 56,
          height: 56,
          borderRadius: 16,
          background: 'white',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          flexShrink: 0,
          border: '1.5px solid #DDA0D8',
          fontSize: 26,
        }}
      >
        ♀
      </div>
      <div style={{ flex: 1, minWidth: 240 }}>
        <div className="font-display uppercase" style={{ fontSize: 22, fontWeight: 800, color: '#6B1A6B', marginBottom: 6 }}>
          Un espacio exclusivo — no un gimmick
        </div>
        <div style={{ fontSize: 14, color: '#4A1A55', lineHeight: 1.65 }}>
          Las mujeres representan el 60%+ del TAM en yoga, pilates y running recreativo. Y son las que más barreras perciben al hacer deporte con desconocidos. El Modo Solo Mujeres no es una opción cosmética — es un requisito de producto para este segmento. Requiere verificación INE completa. Las sesiones en este modo muestran un escudo morado visible para todas las participantes. Solo disponible para usuarias con verificación de identidad completada.
        </div>
        <div style={{ display: 'flex', gap: 20, marginTop: 16, flexWrap: 'wrap' }}>
          <Stat val="60%+" label="del TAM yoga / pilates / running" />
          <Stat val="INE"  label="verificación obligatoria para activarlo" />
          <Stat val="🛡"   label="badge visible en sesión" />
        </div>
      </div>
    </div>
  )
}

function Stat({ val, label }) {
  return (
    <div style={{ textAlign: 'center' }}>
      <div className="font-display" style={{ fontSize: 28, fontWeight: 800, color: '#6B1A6B', lineHeight: 1 }}>{val}</div>
      <div style={{ fontSize: 11, color: '#7A2A7A', marginTop: 2, fontWeight: 500 }}>{label}</div>
    </div>
  )
}
