// Numbered section header used across the plan page.
export default function SectionHeader({ num, title, tone = 'ink', style }) {
  const numStyles =
    tone === 'red'
      ? { background: 'var(--red)', color: 'white' }
      : { background: 'var(--ink)', color: 'white' }

  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, margin: '56px 0 24px', ...style }}>
      <span
        className="font-display uppercase"
        style={{
          ...numStyles,
          fontSize: 11,
          fontWeight: 700,
          letterSpacing: '0.12em',
          padding: '3px 10px',
          borderRadius: 4,
        }}
      >
        {num}
      </span>
      <span
        className="font-display uppercase"
        style={{ fontSize: 22, fontWeight: 700, letterSpacing: '0.02em', color: 'var(--ink)' }}
      >
        {title}
      </span>
      <span style={{ flex: 1, height: 1, background: 'var(--border)' }} />
    </div>
  )
}
