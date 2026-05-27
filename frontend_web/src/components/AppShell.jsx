import BottomTab from './ui/BottomTab.jsx'

// Wraps phone-style screens: status bar, content slot, and bottom tab.
export default function AppShell({ children, hideTabs = false }) {
  return (
    <div className="app-shell" style={{ display: 'flex', flexDirection: 'column' }}>
      <StatusBar />
      <div style={{ flex: 1, overflowY: 'auto' }}>{children}</div>
      {!hideTabs && <BottomTab />}
    </div>
  )
}

function StatusBar() {
  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: '10px 20px 0',
        fontSize: 11,
        fontWeight: 600,
        color: 'var(--ink)',
      }}
    >
      <span>9:41</span>
      <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
        <span style={{ display: 'flex', gap: 2, alignItems: 'flex-end' }}>
          <span style={{ width: 3, height: 4,  background: 'var(--ink)', borderRadius: 1 }} />
          <span style={{ width: 3, height: 7,  background: 'var(--ink)', borderRadius: 1 }} />
          <span style={{ width: 3, height: 10, background: 'var(--ink)', borderRadius: 1 }} />
          <span style={{ width: 3, height: 13, background: 'var(--ink)', borderRadius: 1 }} />
        </span>
        <span>📶</span>
        <span>🔋</span>
      </div>
    </div>
  )
}
