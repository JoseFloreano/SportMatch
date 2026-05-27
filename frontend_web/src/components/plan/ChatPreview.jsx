import { Lock } from 'lucide-react'
import { chatPreview } from '../../data/mockData.js'

export default function ChatPreview() {
  return (
    <div style={{ background: 'var(--mist)', borderRadius: 28, padding: 28 }}>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: 10,
          marginBottom: 20,
          paddingBottom: 16,
          borderBottom: '1px solid var(--border)',
        }}
      >
        <div
          style={{
            width: 38,
            height: 38,
            borderRadius: '50%',
            background: 'var(--teal)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: 'white',
            fontWeight: 700,
            fontSize: 14,
          }}
        >
          {chatPreview.initials}
        </div>
        <div>
          <div style={{ fontWeight: 600, fontSize: 14, color: 'var(--ink)' }}>{chatPreview.name}</div>
          <div style={{ fontSize: 11, color: 'var(--green)', display: 'flex', alignItems: 'center', gap: 4 }}>
            {chatPreview.verified}
          </div>
        </div>
      </div>

      <div
        style={{
          background: 'white',
          border: '1px solid var(--border)',
          borderRadius: 10,
          padding: '10px 14px',
          fontSize: 12,
          color: 'var(--slate)',
          textAlign: 'center',
          marginBottom: 14,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 8,
        }}
      >
        🔒 La ubicación exacta se revela cuando ambas confirmen. Zona actual:&nbsp;<strong>{chatPreview.zone}</strong>
      </div>

      {chatPreview.bubbles.map((b, i) => (
        <div
          key={i}
          style={{ display: 'flex', gap: 8, marginBottom: 10, justifyContent: b.from === 'me' ? 'flex-end' : 'flex-start' }}
        >
          {b.from !== 'me' && <Av initials={b.av} tone="teal" />}
          <div
            style={{
              background: b.from === 'me' ? 'var(--ink)' : 'white',
              color: b.from === 'me' ? 'white' : 'var(--ink)',
              border: b.from === 'me' ? '1px solid var(--ink)' : '1px solid var(--border)',
              borderRadius: 14,
              padding: '10px 14px',
              fontSize: 13,
              maxWidth: 260,
              lineHeight: 1.5,
            }}
          >
            {b.text}
          </div>
          {b.from === 'me' && <Av initials={b.av} tone="volt" />}
        </div>
      ))}

      <button
        type="button"
        className="font-display uppercase"
        style={{
          marginTop: 16,
          width: '100%',
          background: 'var(--ink)',
          color: 'white',
          border: 'none',
          borderRadius: 12,
          padding: 14,
          fontSize: 15,
          fontWeight: 700,
          letterSpacing: '0.06em',
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 8,
        }}
      >
        <Lock size={16} color="var(--volt)" /> Confirmar punto de encuentro
      </button>
    </div>
  )
}

function Av({ initials, tone }) {
  const bg = tone === 'volt' ? '#F0FFD0' : 'var(--teal-light)'
  const color = tone === 'volt' ? 'var(--volt-dark)' : 'var(--teal)'
  return (
    <div
      style={{
        width: 28,
        height: 28,
        borderRadius: '50%',
        background: bg,
        color,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: 11,
        fontWeight: 700,
        flexShrink: 0,
      }}
    >
      {initials}
    </div>
  )
}
