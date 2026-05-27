// Animated user location dot (pulse ring).
export default function UserDot({ x = 50, y = 50 }) {
  return (
    <div
      style={{
        position: 'absolute',
        left: `${x}%`,
        top: `${y}%`,
        transform: 'translate(-50%, -50%)',
        width: 20,
        height: 20,
        zIndex: 11,
      }}
    >
      <span
        className="animate-pulse-ring"
        style={{
          position: 'absolute',
          inset: 0,
          borderRadius: '50%',
          border: '2px solid rgba(0,180,160,0.4)',
        }}
      />
      <span
        style={{
          position: 'absolute',
          inset: 3,
          width: 14,
          height: 14,
          borderRadius: '50%',
          background: 'var(--teal)',
          border: '3px solid white',
          boxShadow: '0 2px 8px rgba(0,180,160,0.5)',
        }}
      />
    </div>
  )
}
