import Avatar from '../ui/Avatar.jsx'
import Badge from '../ui/Badge.jsx'

export default function ProfileHero({ profile }) {
  return (
    <div style={{ background: 'var(--ink)', padding: '24px 20px 20px', position: 'relative', overflow: 'hidden' }}>
      <div
        style={{
          position: 'absolute',
          bottom: -40,
          right: -40,
          width: 160,
          height: 160,
          borderRadius: '50%',
          background: 'var(--teal)',
          opacity: 0.1,
        }}
      />
      <div style={{ position: 'relative', display: 'flex', alignItems: 'flex-end', gap: 14, marginBottom: 14 }}>
        <Avatar initials={profile.initials} tone="teal" size={68} radius={20} fontSize={26} bordered />
        <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
          {profile.verified.ine && <Badge variant="ine" icon="✓">INE verificada</Badge>}
          {profile.verified.phone && <Badge variant="phone" icon="✓">Teléfono</Badge>}
        </div>
      </div>
      <h1 className="font-display uppercase" style={{ fontSize: 24, fontWeight: 800, color: 'white', marginBottom: 2 }}>
        {profile.name}
      </h1>
      <div style={{ fontSize: 12, color: 'rgba(255,255,255,0.5)' }}>
        {profile.zone} · {profile.memberSince}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 12 }}>
        <span style={{ color: 'var(--volt)', fontSize: 14, letterSpacing: 1 }}>★★★★★</span>
        <span className="font-display" style={{ fontSize: 22, fontWeight: 800, color: 'white' }}>{profile.rating}</span>
        <span style={{ fontSize: 12, color: 'rgba(255,255,255,0.4)' }}>· {profile.ratingCount} sesiones</span>
      </div>
    </div>
  )
}
