import AppShell from '../components/AppShell.jsx'

// Used for routes that are part of the tab bar but not implemented yet
// (Eventos, Chats). Keeps navigation honest.
export default function PlaceholderPage({ title, description }) {
  return (
    <AppShell>
      <div style={{ padding: '40px 24px', textAlign: 'center' }}>
        <div className="font-display uppercase" style={{ fontSize: 22, fontWeight: 800, color: 'var(--ink)', marginBottom: 8 }}>
          {title}
        </div>
        <p style={{ fontSize: 14, color: 'var(--slate)', lineHeight: 1.6 }}>
          {description ?? 'Pronto disponible.'}
        </p>
      </div>
    </AppShell>
  )
}
