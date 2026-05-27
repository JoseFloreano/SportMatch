// Status badge with icon + text. Variants tied to design tokens.
const VARIANTS = {
  ine:    { bg: 'rgba(200,255,0,0.2)', color: '#C8FF00', border: 'rgba(200,255,0,0.3)' },
  phone:  { bg: 'rgba(0,180,160,0.2)', color: '#7AF5E8', border: 'rgba(0,180,160,0.3)' },
  event:  { bg: 'var(--amber-light)',  color: '#7A4100', border: 'var(--amber)' },
  women:  { bg: 'var(--purple-light)', color: '#6B1A6B', border: '#DDA0D8' },
  req:    { bg: 'var(--ink)',          color: 'white',    border: 'var(--ink)' },
  opt:    { bg: 'var(--mist)',         color: 'var(--ink-mid)', border: 'var(--mist)' },
  new:    { bg: 'var(--volt)',         color: 'var(--ink)', border: 'var(--volt)' },
  green:  { bg: 'var(--green-light)',  color: '#1A6B3E',  border: '#A0D9B8' },
  amber:  { bg: 'var(--amber-light)',  color: '#7A4100',  border: '#FAC775' },
  red:    { bg: 'var(--red-light)',    color: '#8B1A1A',  border: '#F7C1C1' },
  neutral:{ bg: 'white',               color: 'var(--ink-mid)', border: 'var(--border)' },
}

export default function Badge({ variant = 'neutral', icon, children, className = '', style }) {
  const v = VARIANTS[variant] ?? VARIANTS.neutral
  return (
    <span
      className={`inline-flex items-center gap-1.5 font-medium ${className}`}
      style={{
        background: v.bg,
        color: v.color,
        border: `1px solid ${v.border}`,
        fontSize: '11px',
        padding: '3px 9px',
        borderRadius: '6px',
        ...style,
      }}
    >
      {icon && <span>{icon}</span>}
      <span>{children}</span>
    </span>
  )
}
