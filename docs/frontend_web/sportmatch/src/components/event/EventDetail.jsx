import { ArrowLeft, Trophy, MessageCircle } from 'lucide-react'
import WodBlock from './WodBlock.jsx'
import LevelAvailability from './LevelAvailability.jsx'

// Full event detail UI used by EventDetailPage.
export default function EventDetail({ event, onBack, onRegister, onChat }) {
  return (
    <div>
      {/* HERO */}
      <div
        style={{
          background: 'var(--ink)',
          padding: 20,
          position: 'relative',
          overflow: 'hidden',
        }}
      >
        <div
          style={{
            position: 'absolute',
            top: -40,
            right: -40,
            width: 180,
            height: 180,
            borderRadius: '50%',
            background: 'var(--amber)',
            opacity: 0.12,
          }}
        />
        <div style={{ position: 'relative', display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
          <button
            onClick={onBack}
            aria-label="Volver"
            style={{ color: 'rgba(255,255,255,0.7)', background: 'transparent', border: 'none', cursor: 'pointer', display: 'flex' }}
          >
            <ArrowLeft size={20} />
          </button>
          <span
            className="font-body"
            style={{
              background: 'rgba(245,166,35,0.2)',
              border: '1px solid rgba(245,166,35,0.4)',
              borderRadius: 6,
              padding: '4px 10px',
              fontSize: 11,
              fontWeight: 600,
              color: 'var(--amber)',
              display: 'inline-flex',
              alignItems: 'center',
              gap: 6,
            }}
          >
            🏆 {event.sponsorLabel.replace('🏆 ', '')}
          </span>
        </div>
        <h1
          className="font-display uppercase"
          style={{ fontSize: 26, fontWeight: 800, color: 'white', lineHeight: 1.05, marginBottom: 8 }}
        >
          {event.title}
        </h1>
        <div style={{ fontSize: 13, color: 'rgba(255,255,255,0.55)' }}>
          {event.date} · {event.time} · {event.location}
        </div>
      </div>

      {/* BODY */}
      <div style={{ padding: 16, overflowY: 'auto' }}>
        {/* stats */}
        <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
          {event.stats.map((st, i) => (
            <div
              key={i}
              style={{ flex: 1, background: 'var(--mist)', borderRadius: 12, padding: '12px 10px', textAlign: 'center' }}
            >
              <div className="font-display" style={{ fontSize: 20, fontWeight: 800, color: 'var(--ink)', lineHeight: 1 }}>
                {st.val}
              </div>
              <div style={{ fontSize: 10, color: 'var(--slate)', fontWeight: 500, marginTop: 3 }}>{st.label}</div>
            </div>
          ))}
        </div>

        {/* gym */}
        <div
          style={{
            display: 'flex',
            gap: 12,
            alignItems: 'center',
            background: 'var(--amber-light)',
            border: '1.5px solid var(--amber)',
            borderRadius: 14,
            padding: 14,
            marginBottom: 14,
          }}
        >
          <div
            style={{
              width: 48,
              height: 48,
              borderRadius: 12,
              background: 'var(--ink)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: 22,
              flexShrink: 0,
            }}
          >
            {event.gym.logo}
          </div>
          <div>
            <div className="font-display uppercase" style={{ fontSize: 16, fontWeight: 700, color: 'var(--ink)', marginBottom: 2 }}>
              {event.gym.name}
            </div>
            <div style={{ fontSize: 12, color: 'var(--slate)' }}>{event.gym.address}</div>
            <div style={{ fontSize: 11, color: '#7A4100', fontWeight: 600, marginTop: 4 }}>{event.gym.verified}</div>
          </div>
        </div>

        <WodBlock wod={event.wod} />

        <div
          style={{
            fontSize: 11,
            fontWeight: 700,
            letterSpacing: '0.08em',
            textTransform: 'uppercase',
            color: 'var(--slate)',
            marginBottom: 10,
          }}
        >
          Disponibilidad por nivel
        </div>
        <LevelAvailability availability={event.availability} />

        <button
          onClick={onRegister}
          className="font-display uppercase"
          style={{
            width: '100%',
            background: 'var(--amber)',
            color: 'var(--ink)',
            fontSize: 16,
            fontWeight: 800,
            letterSpacing: '0.08em',
            border: 'none',
            borderRadius: 14,
            padding: 15,
            cursor: 'pointer',
            marginBottom: 10,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
          }}
        >
          <Trophy size={18} /> Inscribirme al evento
        </button>
        <button
          onClick={onChat}
          className="font-display uppercase"
          style={{
            width: '100%',
            background: 'var(--mist)',
            color: 'var(--ink)',
            fontSize: 14,
            fontWeight: 700,
            letterSpacing: '0.06em',
            border: 'none',
            borderRadius: 14,
            padding: 12,
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 6,
          }}
        >
          <MessageCircle size={16} /> Chat con asistentes primero
        </button>
      </div>
    </div>
  )
}
