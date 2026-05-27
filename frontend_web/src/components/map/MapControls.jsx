import { Plus, Minus, LocateFixed } from 'lucide-react'

export default function MapControls({ onZoomIn, onZoomOut, onLocate }) {
  const btn = {
    width: 36,
    height: 36,
    background: 'white',
    borderRadius: 10,
    border: 'none',
    boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
    color: 'var(--ink)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    cursor: 'pointer',
  }
  return (
    <div
      style={{
        position: 'absolute',
        right: 12,
        bottom: 12,
        display: 'flex',
        flexDirection: 'column',
        gap: 6,
        zIndex: 12,
      }}
    >
      <button style={btn} onClick={onZoomIn} aria-label="Zoom in"><Plus size={18} /></button>
      <button style={btn} onClick={onZoomOut} aria-label="Zoom out"><Minus size={18} /></button>
      <button style={btn} onClick={onLocate} aria-label="Recenter"><LocateFixed size={17} /></button>
    </div>
  )
}
