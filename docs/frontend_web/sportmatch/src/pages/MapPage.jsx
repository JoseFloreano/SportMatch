import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Bell, Plus } from 'lucide-react'
import AppShell from '../components/AppShell.jsx'
import MapArea from '../components/map/MapArea.jsx'
import Chip from '../components/ui/Chip.jsx'
import SessionFeed from '../components/session/SessionFeed.jsx'
import Avatar from '../components/ui/Avatar.jsx'
import { filters, sessions, mapPins, userProfile } from '../data/mockData.js'

export default function MapPage() {
  const navigate = useNavigate()
  const [activeFilter, setActiveFilter] = useState('funcional')

  const filteredSessions = useMemo(() => {
    if (activeFilter === 'funcional') return sessions
    if (activeFilter === 'eventos')   return sessions.filter((s) => s.isEvent)
    return sessions.filter((s) => s.sport === activeFilter)
  }, [activeFilter])

  return (
    <AppShell>
      {/* App nav */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px 20px 8px' }}>
        <div className="font-display uppercase" style={{ fontSize: 22, fontWeight: 800, color: 'var(--ink)', letterSpacing: '-0.02em' }}>
          Sport<span style={{ color: 'var(--volt-dark)' }}>Match</span>
        </div>
        <div style={{ display: 'flex', gap: 14, alignItems: 'center' }}>
          <button
            aria-label="Notifications"
            style={{
              width: 34, height: 34, borderRadius: 10,
              background: 'var(--mist)', border: 'none', cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--ink)',
            }}
          >
            <Bell size={16} />
          </button>
          <button
            onClick={() => navigate('/profile')}
            aria-label="Profile"
            style={{ background: 'transparent', border: 'none', cursor: 'pointer', padding: 0 }}
          >
            <Avatar initials={userProfile.initials} tone="teal" size={34} radius={999} fontSize={12} />
          </button>
        </div>
      </div>

      {/* Map */}
      <MapArea pins={mapPins} />

      {/* Filter chips */}
      <div className="no-scrollbar" style={{ display: 'flex', gap: 8, padding: '10px 16px', overflowX: 'auto' }}>
        {filters.map((f) => (
          <Chip
            key={f.id}
            label={f.label}
            emoji={f.emoji}
            variant={f.variant}
            active={activeFilter === f.id}
            onClick={() => setActiveFilter(f.id)}
          />
        ))}
      </div>

      {/* Feed */}
      <SessionFeed sessions={filteredSessions} title={`Cerca de ti · ${filteredSessions.length} ${filteredSessions.length === 1 ? 'sesión' : 'sesiones'}`} />

      {/* FAB */}
      <button
        onClick={() => navigate('/publish')}
        aria-label="Publicar sesión"
        style={{
          position: 'fixed',
          bottom: 96,
          right: 'max(16px, calc(50vw - 220px + 16px))',
          width: 52,
          height: 52,
          borderRadius: 16,
          background: 'var(--volt)',
          border: 'none',
          color: 'var(--ink)',
          fontSize: 24,
          fontWeight: 300,
          boxShadow: '0 6px 20px rgba(200,255,0,0.4), 0 2px 8px rgba(0,0,0,0.1)',
          cursor: 'pointer',
          zIndex: 20,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        <Plus size={24} strokeWidth={2.4} />
      </button>
    </AppShell>
  )
}
