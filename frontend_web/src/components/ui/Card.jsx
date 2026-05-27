// Container card with token-based variants.
const VARIANTS = {
  default: { background: 'white',              border: '1px solid var(--border)',     color: 'var(--ink)' },
  event:   { background: 'var(--amber-light)', border: '1.5px solid var(--amber)',    color: 'var(--ink)' },
  women:   { background: '#F8F0FF',            border: '1.5px solid #DDA0D8',         color: '#6B1A6B' },
  ink:     { background: 'var(--ink)',         border: '1px solid var(--ink)',        color: 'white' },
  mist:    { background: 'var(--mist)',        border: '1px solid var(--mist)',       color: 'var(--ink)' },
}

const RADIUS = { sm: 12, md: 16, lg: 20, xl: 28 }

export default function Card({
  variant = 'default',
  radius = 'lg',
  padding = 16,
  children,
  className = '',
  style,
  onClick,
}) {
  const v = VARIANTS[variant] ?? VARIANTS.default
  return (
    <div
      onClick={onClick}
      className={className}
      style={{
        ...v,
        borderRadius: RADIUS[radius] ?? RADIUS.lg,
        padding,
        cursor: onClick ? 'pointer' : undefined,
        ...style,
      }}
    >
      {children}
    </div>
  )
}
