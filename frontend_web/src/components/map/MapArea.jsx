import MapPin from './MapPin.jsx'
import UserDot from './UserDot.jsx'
import MapControls from './MapControls.jsx'

// Decorative SVG/CSS map (no Leaflet/Mapbox yet). Streets are drawn as positioned
// rectangles, then pins (children data) are absolutely placed using x/y percentages.
export default function MapArea({ pins = [], onPinClick }) {
  return (
    <div
      style={{
        position: 'relative',
        height: 320,
        background: '#E8EDF2',
        overflow: 'hidden',
      }}
    >
      {/* grid background */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          backgroundImage:
            'linear-gradient(rgba(255,255,255,0.6) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.6) 1px, transparent 1px)',
          backgroundSize: '36px 36px',
        }}
      />

      {/* streets (positioned by % to scale with width) */}
      <div style={{ position: 'absolute', left: 0, right: 0, top: '34%', height: 16, background: 'white', opacity: 0.95 }} />
      <div style={{ position: 'absolute', left: 0, right: 0, top: '69%', height: 16, background: 'white', opacity: 0.95 }} />
      <div style={{ position: 'absolute', top: 0, bottom: 0, left: '25%', width: 16, background: 'white', opacity: 0.95 }} />
      <div style={{ position: 'absolute', top: 0, bottom: 0, left: '62%', width: 16, background: 'white', opacity: 0.95 }} />
      <div style={{ position: 'absolute', left: 0, right: 0, top: '17%', height: 10, background: 'white', opacity: 0.85 }} />
      <div style={{ position: 'absolute', left: 0, right: 0, top: '52%', height: 10, background: 'white', opacity: 0.85 }} />
      <div style={{ position: 'absolute', left: 0, right: 0, top: '84%', height: 10, background: 'white', opacity: 0.85 }} />
      <div style={{ position: 'absolute', top: 0, bottom: 0, left: '44%', width: 10, background: 'white', opacity: 0.85 }} />
      <div style={{ position: 'absolute', top: 0, bottom: 0, left: '81%', width: 10, background: 'white', opacity: 0.85 }} />

      {/* park */}
      <div
        style={{
          position: 'absolute',
          left: '28%',
          top: '39%',
          width: '32%',
          height: 80,
          background: '#C8E6C0',
          borderRadius: 8,
        }}
      />

      {/* user location dot */}
      <UserDot x={62} y={55} />

      {/* pins */}
      {pins.map((p) => (
        <MapPin key={p.id} {...p} onClick={() => onPinClick?.(p)} />
      ))}

      <MapControls />
    </div>
  )
}
