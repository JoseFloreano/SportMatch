import { summaryRows } from '../../data/mockData.js'

const STATUS_TONES = {
  req: { background: 'var(--ink)',  color: 'var(--volt)' },
  opt: { background: 'var(--mist)', color: 'var(--ink-mid)' },
  new: { background: 'var(--volt)', color: 'var(--ink)' },
}

const TH = {
  fontFamily: "'Barlow Condensed', sans-serif",
  fontSize: 12,
  fontWeight: 700,
  textTransform: 'uppercase',
  letterSpacing: '0.08em',
  color: 'var(--slate)',
  padding: '8px 14px',
  textAlign: 'left',
  background: 'var(--mist)',
  borderBottom: '1px solid var(--border)',
}

const TD = {
  padding: '13px 14px',
  fontSize: 13,
  borderBottom: '1px solid var(--border)',
  verticalAlign: 'top',
}

export default function SummaryTable() {
  return (
    <div style={{ border: '1px solid var(--border)', borderRadius: 20, overflow: 'hidden' }}>
      <div style={{ overflowX: 'auto' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              <th style={TH}>Capa de seguridad</th>
              <th style={TH}>Estado</th>
              <th style={TH}>Impacto</th>
              <th style={TH}>Aplica para</th>
            </tr>
          </thead>
          <tbody>
            {summaryRows.map((r, i) => {
              const last = i === summaryRows.length - 1
              const tone = STATUS_TONES[r.status]
              return (
                <tr key={r.title}>
                  <td style={{ ...TD, borderBottom: last ? 'none' : TD.borderBottom }}>
                    <strong>{r.title}</strong>
                    <br />
                    <span style={{ color: 'var(--slate)', fontSize: 12 }}>{r.sub}</span>
                  </td>
                  <td style={{ ...TD, borderBottom: last ? 'none' : TD.borderBottom }}>
                    <span
                      style={{
                        display: 'inline-flex',
                        fontSize: 11,
                        fontWeight: 600,
                        padding: '3px 10px',
                        borderRadius: 5,
                        background: tone.background,
                        color: tone.color,
                      }}
                    >
                      {r.statusLabel}
                    </span>
                  </td>
                  <td style={{ ...TD, borderBottom: last ? 'none' : TD.borderBottom }}>
                    <div style={{ display: 'flex', gap: 3 }}>
                      {Array.from({ length: 5 }).map((_, j) => (
                        <span
                          key={j}
                          style={{
                            width: 12,
                            height: 12,
                            borderRadius: 3,
                            background: j < r.impact ? 'var(--red)' : 'var(--mist)',
                            border: j < r.impact ? 'none' : '1px solid var(--border)',
                          }}
                        />
                      ))}
                    </div>
                  </td>
                  <td style={{ ...TD, fontSize: 12, color: 'var(--slate)', borderBottom: last ? 'none' : TD.borderBottom }}>
                    {r.applies}
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </div>
  )
}
