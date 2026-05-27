import { AlertTriangle } from 'lucide-react'

export default function SecuritySection() {
  return (
    <div
      style={{
        background: 'var(--red-light)',
        border: '1.5px solid var(--red)',
        borderRadius: 20,
        padding: '24px 28px',
        display: 'flex',
        gap: 20,
        alignItems: 'flex-start',
        marginBottom: 32,
      }}
    >
      <div
        style={{
          width: 48,
          height: 48,
          borderRadius: 12,
          background: 'var(--red)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          flexShrink: 0,
        }}
      >
        <AlertTriangle size={24} color="white" />
      </div>
      <div>
        <div
          className="font-display uppercase"
          style={{ fontSize: 18, fontWeight: 700, color: 'var(--red)', marginBottom: 6 }}
        >
          Una mala experiencia viral = cierre del producto
        </div>
        <div style={{ fontSize: 14, color: '#7A1A1A', lineHeight: 1.6 }}>
          No hay segunda oportunidad en early stage. El sistema de confianza es la condición de entrada al mercado, especialmente para el segmento femenino que representa el 60%+ del TAM en deporte funcional. Mitigación: 6 capas de verificación, comenzando desde el número de teléfono hasta verificación INE.
        </div>
      </div>
    </div>
  )
}
