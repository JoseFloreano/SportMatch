// Controlled toggle: value: bool, onChange: (next) => void
export default function Toggle({ value, onChange, ariaLabel }) {
  const on = !!value
  return (
    <button
      type="button"
      role="switch"
      aria-checked={on}
      aria-label={ariaLabel}
      onClick={() => onChange?.(!on)}
      style={{
        width: 42,
        height: 24,
        borderRadius: 12,
        padding: 3,
        display: 'flex',
        alignItems: 'center',
        justifyContent: on ? 'flex-end' : 'flex-start',
        background: on ? 'var(--ink)' : 'var(--border)',
        border: 'none',
        cursor: 'pointer',
        transition: 'background 0.2s',
        flexShrink: 0,
      }}
    >
      <span
        style={{
          width: 18,
          height: 18,
          borderRadius: '50%',
          background: on ? 'var(--volt)' : 'white',
          transition: 'background 0.2s',
        }}
      />
    </button>
  )
}
