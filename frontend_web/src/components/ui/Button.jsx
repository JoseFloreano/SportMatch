// Reusable button. Variants: ink, volt, mist, amber. Sizes: sm, md, lg.
const VARIANTS = {
  ink:   { bg: 'var(--ink)',    color: 'var(--volt)', border: 'var(--ink)' },
  volt:  { bg: 'var(--volt)',   color: 'var(--ink)',  border: 'var(--volt)' },
  mist:  { bg: 'var(--mist)',   color: 'var(--ink)',  border: 'var(--mist)' },
  amber: { bg: 'var(--amber)',  color: 'var(--ink)',  border: 'var(--amber)' },
}

const SIZES = {
  sm: { padding: '6px 12px', fontSize: '11px', radius: '8px' },
  md: { padding: '12px 16px', fontSize: '14px', radius: '12px' },
  lg: { padding: '15px 20px', fontSize: '16px', radius: '14px' },
}

export default function Button({
  variant = 'ink',
  size = 'md',
  fullWidth = false,
  onClick,
  children,
  type = 'button',
  className = '',
  ...rest
}) {
  const v = VARIANTS[variant] ?? VARIANTS.ink
  const s = SIZES[size] ?? SIZES.md
  return (
    <button
      type={type}
      onClick={onClick}
      className={`font-display uppercase font-bold tracking-wider transition-transform active:scale-[0.98] cursor-pointer inline-flex items-center justify-center gap-2 ${className}`}
      style={{
        background: v.bg,
        color: v.color,
        border: `1.5px solid ${v.border}`,
        padding: s.padding,
        fontSize: s.fontSize,
        borderRadius: s.radius,
        letterSpacing: '0.08em',
        width: fullWidth ? '100%' : undefined,
      }}
      {...rest}
    >
      {children}
    </button>
  )
}
