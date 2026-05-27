export default function ProfileStats({ stats }) {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginBottom: 16 }}>
      {stats.map((s, i) => (
        <div key={i} style={{ background: 'var(--mist)', borderRadius: 12, padding: '12px 8px', textAlign: 'center' }}>
          <div className="font-display" style={{ fontSize: 22, fontWeight: 800, color: 'var(--ink)', lineHeight: 1 }}>
            {s.val}
          </div>
          <div style={{ fontSize: 10, color: 'var(--slate)', fontWeight: 500, marginTop: 3 }}>{s.label}</div>
        </div>
      ))}
    </div>
  )
}
