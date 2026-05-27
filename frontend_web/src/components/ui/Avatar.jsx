// Avatar that renders initials (or emoji). Tones map to mock palette.
const TONES = {
  teal:   { bg: 'var(--teal)',         color: 'white' },
  green:  { bg: 'var(--green-light)',  color: '#1A6B3E' },
  amber:  { bg: 'var(--amber-light)',  color: '#7A4100' },
  event:  { bg: 'var(--amber)',        color: 'var(--ink)' },
  tealLight: { bg: 'var(--teal-light)', color: '#005A52' },
  ink:    { bg: 'var(--ink)',          color: 'var(--volt)' },
}

export default function Avatar({ initials, emoji, tone = 'teal', size = 40, radius = 12, bordered = false, fontSize }) {
  const t = TONES[tone] ?? TONES.teal
  return (
    <div
      className="font-display font-bold inline-flex items-center justify-center shrink-0"
      style={{
        width: size,
        height: size,
        background: t.bg,
        color: t.color,
        borderRadius: radius,
        fontSize: fontSize ?? Math.max(11, Math.floor(size * 0.42)),
        border: bordered ? '3px solid rgba(255,255,255,0.2)' : undefined,
      }}
    >
      {emoji ?? initials}
    </div>
  )
}
