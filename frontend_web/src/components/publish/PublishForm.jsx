import { useState } from 'react'
import { Zap } from 'lucide-react'
import { sports as defaultSports, levels as defaultLevels } from '../../data/mockData.js'
import SportSelector from './SportSelector.jsx'
import LevelSelector from './LevelSelector.jsx'
import Toggle from '../ui/Toggle.jsx'

const SECTION_LABEL = {
  fontSize: 11,
  fontWeight: 700,
  letterSpacing: '0.08em',
  textTransform: 'uppercase',
  color: 'var(--slate)',
  marginBottom: 10,
}

const FIELD_LABEL = {
  fontSize: 10,
  fontWeight: 700,
  textTransform: 'uppercase',
  letterSpacing: '0.08em',
  color: 'var(--slate)',
  marginBottom: 3,
}

const FIELD_VAL = {
  fontFamily: "'Barlow Condensed', sans-serif",
  fontSize: 17,
  fontWeight: 700,
  color: 'var(--ink)',
  background: 'transparent',
  border: 'none',
  outline: 'none',
  width: '100%',
}

export default function PublishForm({ onSubmit }) {
  const [sport, setSport] = useState('crossfit')
  const [day, setDay] = useState('Mañana')
  const [time, setTime] = useState('7:00 am')
  const [zone, setZone] = useState('')
  const [level, setLevel] = useState('rx')
  const [womenOnly, setWomenOnly] = useState(false)
  const [whatsapp, setWhatsapp] = useState(true)

  const handleSubmit = (e) => {
    e.preventDefault()
    onSubmit?.({ sport, day, time, zone, level, womenOnly, whatsapp })
  }

  return (
    <form onSubmit={handleSubmit} style={{ padding: 16 }}>
      <div style={SECTION_LABEL}>¿Qué deporte?</div>
      <SportSelector sports={defaultSports} value={sport} onChange={setSport} />

      <div style={SECTION_LABEL}>Cuándo y dónde</div>
      <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
        <Field label="Día"  value={day}  onChange={setDay} />
        <Field label="Hora" value={time} onChange={setTime} />
      </div>
      <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
        <Field
          label="Zona"
          value={zone}
          onChange={setZone}
          placeholder="Ej. Roma Norte, Parque México"
          flex={1}
        />
      </div>

      <div style={{ ...SECTION_LABEL, marginTop: 4 }}>Nivel</div>
      <LevelSelector levels={defaultLevels} value={level} onChange={setLevel} />

      <div style={SECTION_LABEL}>Opciones</div>
      <ToggleRow
        label="Solo mujeres ♀"
        sub="Requiere verificación INE"
        value={womenOnly}
        onChange={setWomenOnly}
      />
      <ToggleRow
        label="Notificar por WhatsApp"
        sub="Avisa cuando alguien se une"
        value={whatsapp}
        onChange={setWhatsapp}
      />

      <button
        type="submit"
        className="font-display uppercase"
        style={{
          width: '100%',
          marginTop: 16,
          background: 'var(--ink)',
          color: 'var(--volt)',
          fontSize: 16,
          fontWeight: 800,
          letterSpacing: '0.08em',
          border: 'none',
          borderRadius: 14,
          padding: 15,
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 8,
        }}
      >
        <Zap size={18} fill="var(--volt)" /> Publicar en el mapa
      </button>
    </form>
  )
}

function Field({ label, value, onChange, placeholder, flex }) {
  return (
    <label
      style={{
        flex: flex ?? 1,
        background: 'var(--mist)',
        borderRadius: 12,
        padding: '12px 14px',
        cursor: 'text',
        display: 'block',
      }}
    >
      <div style={FIELD_LABEL}>{label}</div>
      <input
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        style={{
          ...FIELD_VAL,
          color: value ? 'var(--ink)' : 'var(--slate)',
          fontWeight: value ? 700 : 400,
        }}
      />
    </label>
  )
}

function ToggleRow({ label, sub, value, onChange }) {
  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        background: 'var(--mist)',
        borderRadius: 12,
        padding: '12px 14px',
        marginBottom: 10,
      }}
    >
      <div>
        <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--ink)' }}>{label}</div>
        <div style={{ fontSize: 11, color: 'var(--slate)' }}>{sub}</div>
      </div>
      <Toggle value={value} onChange={onChange} ariaLabel={label} />
    </div>
  )
}
