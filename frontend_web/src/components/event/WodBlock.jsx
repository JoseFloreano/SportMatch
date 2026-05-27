// Renders an event WOD: label + list of exercises (reps + name + note).
export default function WodBlock({ wod }) {
  return (
    <div style={{ background: 'var(--mist)', borderRadius: 14, padding: 14, marginBottom: 14 }}>
      <div
        style={{
          fontSize: 10,
          fontWeight: 700,
          letterSpacing: '0.1em',
          textTransform: 'uppercase',
          color: 'var(--slate)',
          marginBottom: 8,
        }}
      >
        {wod.label}
      </div>
      {wod.exercises.map((ex, i) => (
        <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6 }}>
          <div
            className="font-display"
            style={{ fontSize: 18, fontWeight: 800, color: 'var(--ink)', minWidth: 36, lineHeight: 1 }}
          >
            {ex.reps}
          </div>
          <div>
            <div style={{ fontSize: 13, color: 'var(--ink)', fontWeight: 500 }}>{ex.name}</div>
            <div style={{ fontSize: 11, color: 'var(--slate)' }}>{ex.note}</div>
          </div>
        </div>
      ))}
    </div>
  )
}
