import { useNavigate } from 'react-router-dom'
import { ArrowLeft } from 'lucide-react'
import AppShell from '../components/AppShell.jsx'
import PublishForm from '../components/publish/PublishForm.jsx'

export default function PublishPage() {
  const navigate = useNavigate()
  return (
    <AppShell hideTabs>
      <div
        style={{
          padding: '14px 20px',
          display: 'flex',
          alignItems: 'center',
          gap: 10,
          borderBottom: '1px solid var(--border)',
        }}
      >
        <button
          onClick={() => navigate('/')}
          aria-label="Volver"
          style={{
            width: 32,
            height: 32,
            borderRadius: 10,
            background: 'var(--mist)',
            border: 'none',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: 'var(--ink)',
            cursor: 'pointer',
          }}
        >
          <ArrowLeft size={18} />
        </button>
        <div className="font-display uppercase" style={{ fontSize: 17, fontWeight: 700, color: 'var(--ink)', flex: 1 }}>
          Publicar sesión
        </div>
      </div>

      <PublishForm
        onSubmit={(data) => {
          // En una integración real esto haría POST al backend. Por ahora solo
          // volvemos al mapa: la nueva sesión "aparece" en el feed.
          console.log('Nueva sesión publicada (mock):', data)
          navigate('/')
        }}
      />
    </AppShell>
  )
}
