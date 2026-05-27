import { NavLink, useLocation } from 'react-router-dom'
import { Map, Trophy, MessageCircle, User } from 'lucide-react'

const TABS = [
  { to: '/',        label: 'Mapa',    Icon: Map },
  { to: '/events',  label: 'Eventos', Icon: Trophy },
  { to: '/chats',   label: 'Chats',   Icon: MessageCircle },
  { to: '/profile', label: 'Perfil',  Icon: User },
]

export default function BottomTab() {
  const location = useLocation()

  return (
    <nav
      style={{
        display: 'flex',
        borderTop: '1px solid var(--border)',
        background: 'white',
        padding: '8px 0 16px',
      }}
    >
      {TABS.map(({ to, label, Icon }) => {
        const active = to === '/' ? location.pathname === '/' : location.pathname.startsWith(to)
        return (
          <NavLink
            key={to}
            to={to}
            style={{
              flex: 1,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              gap: 3,
              textDecoration: 'none',
              color: 'var(--slate)',
            }}
          >
            <span
              style={{
                background: active ? 'var(--ink)' : 'transparent',
                borderRadius: 12,
                padding: active ? '4px 14px' : '4px 0',
                color: active ? 'var(--volt)' : 'var(--slate)',
                display: 'inline-flex',
              }}
            >
              <Icon size={20} strokeWidth={active ? 2.2 : 1.8} />
            </span>
            <span style={{ fontSize: 10, fontWeight: 600, color: active ? 'var(--ink)' : 'var(--slate)' }}>
              {label}
            </span>
          </NavLink>
        )
      })}
    </nav>
  )
}
