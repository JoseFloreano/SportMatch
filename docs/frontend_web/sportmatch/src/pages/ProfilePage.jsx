import { useState } from 'react'
import AppShell from '../components/AppShell.jsx'
import ProfileHero from '../components/profile/ProfileHero.jsx'
import ProfileStats from '../components/profile/ProfileStats.jsx'
import SportPrefs from '../components/profile/SportPrefs.jsx'
import ScheduleGrid from '../components/profile/ScheduleGrid.jsx'
import Toggle from '../components/ui/Toggle.jsx'
import { userProfile } from '../data/mockData.js'

export default function ProfilePage() {
  const [womenMode, setWomenMode] = useState(userProfile.womenMode)

  return (
    <AppShell>
      <ProfileHero profile={userProfile} />

      <div style={{ padding: 16 }}>
        <ProfileStats stats={userProfile.stats} />
        <SportPrefs prefs={userProfile.sportPrefs} />
        <ScheduleGrid schedule={userProfile.schedule} />

        <div
          style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            background: '#F8F0FF',
            border: '1.5px solid #DDA0D8',
            borderRadius: 14,
            padding: 14,
            marginBottom: 16,
          }}
        >
          <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
            <div style={{ fontSize: 24 }}>♀</div>
            <div>
              <div className="font-display uppercase" style={{ fontSize: 15, fontWeight: 700, color: '#6B1A6B', marginBottom: 2 }}>
                Modo solo mujeres
              </div>
              <div style={{ fontSize: 11, color: '#7A2A7A' }}>
                Solo apareces en sesiones de mujeres
              </div>
            </div>
          </div>
          <Toggle value={womenMode} onChange={setWomenMode} ariaLabel="Modo solo mujeres" />
        </div>
      </div>
    </AppShell>
  )
}
