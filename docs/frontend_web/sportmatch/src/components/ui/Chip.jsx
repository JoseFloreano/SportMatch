// Filter chip: default vs active (ink + volt). variant="event" gives amber border styling.
export default function Chip({ label, emoji, active = false, variant = 'default', onClick }) {
  const styles =
    variant === 'event' && !active
      ? { background: 'var(--amber-light)', color: '#7A4100', border: '1.5px solid var(--amber)' }
      : active
      ? { background: 'var(--ink)', color: 'var(--volt)', border: '1.5px solid var(--ink)' }
      : { background: 'white', color: 'var(--slate)', border: '1.5px solid var(--border)' }

  return (
    <button
      type="button"
      onClick={onClick}
      className="no-scrollbar shrink-0 whitespace-nowrap inline-flex items-center gap-1.5 cursor-pointer transition-colors"
      style={{
        ...styles,
        fontSize: '12px',
        fontWeight: 600,
        padding: '6px 14px',
        borderRadius: 999,
      }}
    >
      {emoji && <span>{emoji}</span>}
      <span>{label}</span>
    </button>
  )
}
