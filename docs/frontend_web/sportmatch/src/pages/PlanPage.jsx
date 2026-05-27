import { AlertCircle } from 'lucide-react'
import SectionHeader   from '../components/plan/SectionHeader.jsx'
import BusinessModel   from '../components/plan/BusinessModel.jsx'
import RevenueStream   from '../components/plan/RevenueStream.jsx'
import NichoBlock      from '../components/plan/NichoBlock.jsx'
import SecuritySection from '../components/plan/SecuritySection.jsx'
import SecurityLayers  from '../components/plan/SecurityLayers.jsx'
import IneFlow         from '../components/plan/IneFlow.jsx'
import TrustPillars    from '../components/plan/TrustPillars.jsx'
import RatingsSection  from '../components/plan/RatingsSection.jsx'
import WomenMode       from '../components/plan/WomenMode.jsx'
import ChatPreview     from '../components/plan/ChatPreview.jsx'
import SummaryTable    from '../components/plan/SummaryTable.jsx'
import { revenueStreams, viabilityMetrics } from '../data/mockData.js'

// Plan documental — no es pantalla mobile. Ancho máximo 900px, centrado.
export default function PlanPage() {
  return (
    <div style={{ background: 'white', minHeight: '100vh' }}>
      <Hero />

      <main style={{ maxWidth: 900, margin: '0 auto', padding: '56px 32px 80px' }}>
        <SectionHeader num="01" title="Modelo de negocio — 4 fuentes de ingresos" style={{ marginTop: 0 }} />

        <BusinessModel />

        <div style={{ display: 'grid', gridTemplateColumns: '1fr', gap: 16 }}>
          {revenueStreams.map((s) => (
            <RevenueStream key={s.id} stream={s} />
          ))}
        </div>

        <div
          style={{
            background: 'var(--mist)',
            borderRadius: 20,
            padding: 24,
            marginTop: 20,
            display: 'flex',
            alignItems: 'stretch',
            flexWrap: 'wrap',
          }}
        >
          {viabilityMetrics.map((m, i) => (
            <div
              key={i}
              style={{
                flex: 1,
                minWidth: 140,
                textAlign: 'center',
                padding: '0 16px',
                borderLeft: i > 0 ? '1px solid var(--border)' : 'none',
              }}
            >
              <div className="font-display" style={{ fontSize: 26, fontWeight: 800, color: 'var(--ink)', lineHeight: 1, marginBottom: 4 }}>
                {m.val}
              </div>
              <div style={{ fontSize: 12, color: 'var(--slate)' }}>{m.label}</div>
            </div>
          ))}
        </div>

        <SectionHeader num="02" title="Nicho inicial — Deporte funcional" />
        <NichoBlock />

        <SectionHeader num="!" title="Seguridad y confianza entre desconocidos" tone="red" />
        <SecuritySection />

        <SectionHeader num="03" title="Sistema de verificación por capas" />
        <SecurityLayers />

        <SectionHeader num="04" title="Verificación INE — Cómo funciona" />
        <IneFlow />

        <SectionHeader num="05" title="Los 4 pilares de confianza" />
        <TrustPillars />

        <SectionHeader num="06" title="Sistema de ratings post-sesión" />
        <RatingsSection />

        <SectionHeader num="07" title="Modo Solo Mujeres" />
        <WomenMode />

        <SectionHeader num="08" title="Chat protegido antes de confirmar ubicación" />
        <ChatPreview />

        <SectionHeader num="09" title="Resumen del sistema de seguridad" />
        <SummaryTable />

        <FooterCta />
      </main>
    </div>
  )
}

function Hero() {
  return (
    <header
      style={{
        background: 'var(--ink)',
        padding: '64px 48px 56px',
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      <div
        style={{
          position: 'absolute',
          top: -60,
          right: -60,
          width: 360,
          height: 360,
          borderRadius: '50%',
          background: 'var(--volt)',
          opacity: 0.07,
        }}
      />
      <div
        style={{
          position: 'absolute',
          bottom: -40,
          left: '20%',
          width: 200,
          height: 200,
          borderRadius: '50%',
          background: 'var(--teal)',
          opacity: 0.09,
        }}
      />
      <div
        className="font-display uppercase"
        style={{
          position: 'relative',
          display: 'inline-flex',
          alignItems: 'center',
          gap: 8,
          background: 'rgba(200,255,0,0.12)',
          border: '1px solid rgba(200,255,0,0.3)',
          borderRadius: 999,
          padding: '4px 14px',
          fontSize: 12,
          fontWeight: 600,
          letterSpacing: '0.1em',
          color: 'var(--volt)',
          marginBottom: 20,
        }}
      >
        <span style={{ width: 6, height: 6, borderRadius: '50%', background: 'var(--red)' }} />
        SportMatch — Deporte funcional CDMX
      </div>
      <h1
        className="font-display uppercase"
        style={{
          position: 'relative',
          fontSize: 'clamp(36px, 5vw, 58px)',
          fontWeight: 800,
          lineHeight: 1.05,
          color: 'white',
          letterSpacing: '-0.02em',
          maxWidth: 640,
          marginBottom: 16,
        }}
      >
        Modelo de
        <br />
        negocio &
        <br />
        <em style={{ color: 'var(--volt)', fontStyle: 'normal' }}>Seguridad</em>
      </h1>
      <p style={{ position: 'relative', fontSize: 16, color: 'rgba(255,255,255,0.6)', maxWidth: 560, lineHeight: 1.65 }}>
        Plan completo de SportMatch: tres fuentes de ingresos, eventos deportivos patrocinados, nicho de deporte funcional, y sistema de confianza de 6 capas incluyendo verificación INE. Presentación para equipo fundador.
      </p>
      <div
        style={{
          position: 'relative',
          display: 'inline-flex',
          alignItems: 'center',
          gap: 8,
          marginTop: 28,
          background: 'rgba(232,57,58,0.15)',
          border: '1px solid rgba(232,57,58,0.4)',
          borderRadius: 8,
          padding: '10px 18px',
          color: '#FF7B7C',
          fontSize: 14,
        }}
      >
        <AlertCircle size={18} color="#FF7B7C" />
        <span><strong style={{ color: '#FF9B9B' }}>Enfoque inicial:</strong> deporte funcional (CrossFit, calistenia, HIIT) — CDMX, La Condesa y Roma Norte</span>
      </div>
    </header>
  )
}

function FooterCta() {
  return (
    <div
      style={{
        background: 'var(--ink)',
        borderRadius: 28,
        padding: '36px 32px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        gap: 24,
        flexWrap: 'wrap',
        marginTop: 48,
      }}
    >
      <div>
        <h3 className="font-display uppercase" style={{ fontSize: 26, fontWeight: 800, color: 'white', marginBottom: 4 }}>
          Siguiente paso:<br /><span style={{ color: 'var(--volt)' }}>Mockup de la app</span>
        </h3>
        <p style={{ fontSize: 14, color: 'rgba(255,255,255,0.5)' }}>
          Pantalla de mapa · Evento patrocinado · Perfil verificado · Publicar sesión
        </p>
      </div>
      <a
        href="/"
        className="font-display uppercase"
        style={{
          background: 'var(--volt)',
          color: 'var(--ink)',
          fontSize: 16,
          fontWeight: 800,
          letterSpacing: '0.08em',
          padding: '14px 32px',
          borderRadius: 10,
          border: 'none',
          cursor: 'pointer',
          textDecoration: 'none',
          whiteSpace: 'nowrap',
        }}
      >
        Ver mockup →
      </a>
    </div>
  )
}
