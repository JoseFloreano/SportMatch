// Map pin bubble. Tones: ink (default), volt, teal, event(amber). Optional badge.
const TONES = {
  ink:   { bg: 'var(--ink)',   color: 'white' },
  volt:  { bg: 'var(--volt)',  color: 'var(--ink)' },
  teal:  { bg: 'var(--teal)',  color: 'white' },
  event: { bg: 'var(--amber)', color: 'var(--ink)' },
}

export default function MapPin({ emoji, label, tone = 'ink', badge, x, y, onClick }) {
  const t = TONES[tone] ?? TONES.ink
  return (
    <button
      type="button"
      onClick={onClick}
      style={{
        position: 'absolute',
        left: `${x}%`,
        top: `${y}%`,
        transform: 'translate(-50%, -100%)',
        zIndex: 10,
        cursor: 'pointer',
        border: 'none',
        padding: 0,
        background: 'transparent',
      }}
    >
      <span
        style={{
          background: t.bg,
          color: t.color,
          borderRadius: '20px 20px 20px 4px',
          padding: '6px 10px',
          fontSize: 11,
          fontWeight: 600,
          whiteSpace: 'nowrap',
          display: 'inline-flex',
          alignItems: 'center',
          gap: 5,
          boxShadow: '0 4px 12px rgba(0,0,0,0.2)',
          position: 'relative',
        }}
      >
        <span style={{ fontSize: 13 }}>{emoji}</span>
        {label}
        {badge && (
          <span
            style={{
              position: 'absolute',
              top: -4,
              right: -4,
              width: 14,
              height: 14,
              borderRadius: '50%',
              background: 'var(--red)',
              border: '2px solid white',
              color: 'white',
              fontSize: 8,
              fontWeight: 700,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            {badge}
          </span>
        )}
      </span>
    </button>
  )
}
