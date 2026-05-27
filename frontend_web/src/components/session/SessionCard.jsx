import Avatar from '../ui/Avatar.jsx'

// SessionCard renders one session in the feed.
export default function SessionCard({ session, onAction }) {
  const {
    sportLabel, emoji, userName, rating, zone, distance, sub,
    time, date, level, spots, capacity, isEvent, isWomenOnly,
    isVerified, avatarTone,
  } = session

  const cardStyle = isEvent
    ? { background: 'var(--amber-light)', border: '1.5px solid var(--amber)' }
    : { background: 'var(--mist)', border: '1.5px solid transparent' }

  return (
    <div
      style={{
        ...cardStyle,
        borderRadius: 16,
        padding: 14,
        marginBottom: 10,
        display: 'flex',
        gap: 10,
        alignItems: 'flex-start',
        cursor: 'pointer',
      }}
      onClick={onAction}
    >
      <Avatar emoji={emoji} tone={avatarTone ?? 'teal'} size={40} radius={12} />

      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="font-display uppercase" style={{ fontSize: 15, fontWeight: 700, color: 'var(--ink)', lineHeight: 1.1, marginBottom: 2 }}>
          {sportLabel}
        </div>
        <div style={{ fontSize: 12, color: 'var(--slate)' }}>
          {sub ?? (
            <>
              {zone}
              {distance && ` · ${distance}`}
              {userName && ` · ${userName}`}
              {rating && ` ★${rating}`}
            </>
          )}
        </div>

        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4, marginTop: 6 }}>
          {isEvent && <Tag tone="amber">🏆 Evento</Tag>}
          {capacity && <Tag>{capacity}</Tag>}
          {!isEvent && isVerified && <Tag tone="green">INE ✓</Tag>}
          {isWomenOnly && <Tag tone="amber">Solo mujeres ♀</Tag>}
          {level && <Tag>{level}</Tag>}
          {spots && !isWomenOnly && <Tag tone={isEvent ? 'green' : undefined}>{spots}</Tag>}
        </div>
      </div>

      <div style={{ flexShrink: 0, textAlign: 'right' }}>
        <div className="font-display" style={{ fontSize: 18, fontWeight: 800, color: 'var(--ink)', lineHeight: 1 }}>{time}</div>
        <div style={{ fontSize: 11, color: 'var(--slate)' }}>{distance ?? date}</div>
        <button
          type="button"
          className="font-display uppercase"
          style={{
            marginTop: 6,
            fontSize: 11,
            fontWeight: 700,
            letterSpacing: '0.06em',
            background: isEvent ? 'var(--amber)' : 'var(--ink)',
            color: isEvent ? 'var(--ink)' : 'var(--volt)',
            border: 'none',
            borderRadius: 8,
            padding: '5px 12px',
            cursor: 'pointer',
          }}
          onClick={(e) => { e.stopPropagation(); onAction?.() }}
        >
          {isEvent ? 'Ver →' : 'Unirse'}
        </button>
      </div>
    </div>
  )
}

const TONES = {
  green: { bg: 'var(--green-light)', color: '#1A6B3E', border: '#A0D9B8' },
  amber: { bg: 'var(--amber-light)', color: '#7A4100', border: '#FAC775' },
  red:   { bg: 'var(--red-light)',   color: '#8B1A1A', border: '#F7C1C1' },
}

function Tag({ tone, children }) {
  const t = TONES[tone]
  return (
    <span
      style={{
        fontSize: 10,
        fontWeight: 600,
        padding: '2px 7px',
        borderRadius: 4,
        background: t?.bg ?? 'white',
        color: t?.color ?? 'var(--ink-mid)',
        border: `1px solid ${t?.border ?? 'var(--border)'}`,
      }}
    >
      {children}
    </span>
  )
}
