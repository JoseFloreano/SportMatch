// Mock data extraído de los HTML originales (sportmatch_mockup.html + sportmatch_seguridad.html)

export const sports = [
  { id: 'crossfit',   label: 'CrossFit',   emoji: '🏋️' },
  { id: 'calistenia', label: 'Calistenia', emoji: '🤸' },
  { id: 'hiit',       label: 'HIIT',       emoji: '⚡' },
  { id: 'running',    label: 'Running',    emoji: '🏃' },
  { id: 'tenis',      label: 'Tenis',      emoji: '🎾' },
  { id: 'yoga',       label: 'Yoga',       emoji: '🧘' },
]

export const filters = [
  { id: 'funcional',  label: 'Funcional',  emoji: '🏋️', active: true },
  { id: 'eventos',    label: 'Eventos',    emoji: '🏆', variant: 'event' },
  { id: 'calistenia', label: 'Calistenia', emoji: '🤸' },
  { id: 'hiit',       label: 'HIIT',       emoji: '⚡' },
  { id: 'running',    label: 'Running',    emoji: '🏃' },
  { id: 'tenis',      label: 'Tenis',      emoji: '🎾' },
]

export const sessions = [
  {
    id: 'box-alpha-open',
    sport: 'crossfit',
    sportLabel: 'CrossFit Abierto — Box Alpha',
    emoji: '🏆',
    userName: 'Box Alpha Condesa',
    rating: null,
    zone: 'Roma Norte',
    distance: null,
    sub: 'Patrocinado por Box Alpha Condesa',
    time: '7:00',
    date: 'Mañana',
    level: 'RX · Scaled',
    spots: '3 spots free',
    capacity: '20 cupos',
    isEvent: true,
    isWomenOnly: false,
    isVerified: true,
    avatarTone: 'event',
  },
  {
    id: 'wod-matutino',
    sport: 'crossfit',
    sportLabel: 'WOD Matutino',
    emoji: '🏋️',
    userName: 'Carlos M.',
    rating: 4.9,
    zone: 'Condesa',
    distance: '0.4 km',
    time: '6:30',
    date: 'Hoy',
    level: 'Scaled',
    spots: '1 spot',
    isEvent: false,
    isWomenOnly: false,
    isVerified: true,
    avatarTone: 'teal',
  },
  {
    id: 'calistenia-parque',
    sport: 'calistenia',
    sportLabel: 'Calistenia Parque',
    emoji: '🤸',
    userName: 'Andrea T.',
    rating: 4.7,
    zone: 'Parque México',
    distance: '0.8 km',
    time: '7:30',
    date: 'Hoy',
    level: 'Intermedio',
    spots: 'Solo mujeres ♀',
    isEvent: false,
    isWomenOnly: true,
    isVerified: true,
    avatarTone: 'green',
  },
]

export const events = [
  {
    id: 'box-alpha-open',
    title: 'CrossFit Abierto CDMX',
    sponsor: 'Box Alpha',
    sponsorLabel: '🏆 Evento patrocinado · Box Alpha',
    date: 'Mañana',
    time: '7:00 am',
    location: 'Roma Norte, CDMX',
    stats: [
      { val: '20', label: 'cupos totales' },
      { val: '7',  label: 'spots libres' },
      { val: '$0', label: 'costo entrada' },
    ],
    gym: {
      name: 'Box Alpha Condesa',
      address: 'Tamaulipas 95, Condesa · 0.3 km',
      logo: '⚔️',
      verified: '✓ Espacio verificado SportMatch · Patrocinador oficial',
    },
    wod: {
      label: 'WOD del evento — AMRAP 20 min',
      exercises: [
        { reps: '21', name: 'Thrusters', note: 'RX: 43kg · Scaled: 29kg' },
        { reps: '15', name: 'Pull-ups',  note: 'RX: strict · Scaled: banded' },
        { reps: '9',  name: 'Box Jumps', note: 'RX: 24" · Scaled: 20"' },
      ],
    },
    availability: [
      { level: 'RX',       tone: 'rx', spots: '2 spots' },
      { level: 'Scaled',   tone: 'sc', spots: '4 spots' },
      { level: 'Beginner', tone: 'bg', spots: '1 spot'  },
    ],
  },
]

export const userProfile = {
  id: 'mariana-valdes',
  name: 'Mariana Valdés',
  initials: 'MV',
  zone: 'La Condesa',
  memberSince: 'Miembro desde enero 2025',
  rating: 4.9,
  ratingCount: 34,
  verified: { ine: true, phone: true },
  stats: [
    { val: '34',  label: 'sesiones' },
    { val: '98%', label: 'asistencia' },
    { val: '4',   label: 'eventos' },
  ],
  sportPrefs: [
    { sport: 'crossfit',   emoji: '🏋️', label: 'CrossFit · Scaled', primary: true },
    { sport: 'calistenia', emoji: '🤸', label: 'Calistenia',         primary: false },
    { sport: 'running',    emoji: '🏃', label: 'Running 5k',         primary: false },
  ],
  schedule: {
    days: [
      { code: 'L', active: true  },
      { code: 'M', active: false },
      { code: 'X', active: true  },
      { code: 'J', active: false },
      { code: 'V', active: true  },
      { code: 'S', active: true  },
      { code: 'D', active: false },
    ],
    note: 'Mañanas 6:00–8:00 am · 0.5–1.5 km desde casa',
  },
  womenMode: true,
}

export const levels = [
  { id: 'rx',       name: 'RX',       desc: 'Competitivo', tone: 'rx' },
  { id: 'scaled',   name: 'Scaled',   desc: 'Intermedio',  tone: 'scaled' },
  { id: 'beginner', name: 'Beginner', desc: 'Iniciando',   tone: 'beginner' },
]

// ── Plan content ────────────────────────────────────────────────────────────
export const businessMetrics = [
  { val: '$375K', label: 'MXN/mes objetivo año 1' },
  { val: '4',     label: 'fuentes de ingresos' },
  { val: '500',   label: 'sesiones/mes para viabilidad' },
]

export const revenueStreams = [
  {
    id: 'b2b',
    badge: 'B2B',
    badgeTone: 'b2b',
    cardTone: 'b2b',
    title: 'Promoción de espacios deportivos',
    estimate: '$3K–$15K MXN / mes por cliente',
    description:
      'Gimnasios, boxes de CrossFit, canchas y estudios pagan para aparecer destacados en el mapa cuando alguien busca en su zona. Dos modalidades: paquete mensual de visibilidad (pin destacado + badge "Asociado") y sesiones patrocinadas (el gym publica una clase de prueba gratuita que aparece en el feed de usuarios afines).',
    items: [
      'Pin destacado en mapa',
      'Badge "Espacio verificado"',
      'Sesiones de prueba patrocinadas',
      'Dashboard de métricas',
      '20 clientes → $300K/mes',
    ],
  },
  {
    id: 'events',
    badge: 'Nuevo',
    badgeTone: 'event',
    cardTone: 'events',
    title: 'Eventos deportivos patrocinados',
    estimate: '$5K–$40K MXN / evento',
    description:
      'Un gym o box patrocina un evento en la app — aporta sus instalaciones, equipo e instructores. SportMatch coordina los participantes vía matching, gestiona inscripciones y da visibilidad. El gym gana nuevos prospectos calificados; los usuarios tienen acceso a instalaciones premium de forma gratuita o a precio reducido. El modelo de negocio es comisión + fee de visibilidad.',
    example: {
      thumb: '🏋️',
      label: 'Ejemplo real — Evento patrocinado',
      title: 'CrossFit Abierto — Box Condesa',
      desc:
        'Box Alpha Condesa patrocina un WOD grupal de 90 min para 20 participantes. El box pone las instalaciones, barras, pesas y un coach certificado. SportMatch hace el matching por nivel (RX, Scaled, Beginner), coordina horarios y envía notificaciones por WhatsApp. Los asistentes pagan $0 o $50 MXN simbólico. El box capta datos de 20 prospectos calificados y cobra visibilidad premium en la app por 30 días.',
      tags: [
        'Nicho funcional',
        '20 participantes por evento',
        'Matching por nivel RX/Scaled',
        'Box aporta instalaciones',
        'Notificación WhatsApp',
        'Coach certificado incluido',
      ],
    },
    items: [
      'Fee de organización al gym: $5K–$15K',
      'Visibilidad premium 30 días',
      'Comisión 15% en inscripciones',
      '2 eventos/mes → escala rápido',
    ],
  },
  {
    id: 'free',
    badge: 'B2C — Free',
    badgeTone: 'free',
    cardTone: 'free',
    title: 'Plan gratuito con anuncios',
    estimate: 'RPM $80–$150 MXN · escala con MAU',
    description:
      'Acceso completo a matching y mapa. Anuncios contextuales de marcas deportivas (Asics, Under Armour, Powerade, Rogue) y establecimientos locales. El inventario publicitario es premium porque el usuario está activo y en contexto deportivo — no scrolleando sin objetivo. CPM más alto que redes sociales genéricas.',
    items: [
      'Matching + mapa completo',
      'Anuncios contextuales deportivos',
      'Requiere 50K+ MAU para escalar',
    ],
  },
  {
    id: 'pro',
    badge: 'B2C — Pro',
    badgeTone: 'pro',
    cardTone: 'pro',
    title: 'Plan premium — sin anuncios + matching avanzado',
    estimate: '$99–$149 MXN/mes · 500 usuarios = $75K/mes',
    description:
      'Sin publicidad. Matching con mayor granularidad: pace exacto, nivel de conversación, objetivos de entrenamiento, historial de compañeros con rating. Notificaciones anticipadas antes que usuarios Free. Acceso prioritario a eventos patrocinados y lista de espera preferencial.',
    items: [
      'Cero anuncios',
      'Matching por objetivos de entrenamiento',
      'Acceso prioritario a eventos',
      'Historial y estadísticas avanzadas',
      'Notificaciones anticipadas',
    ],
  },
]

export const viabilityMetrics = [
  { val: '20',    label: 'clientes B2B para $300K/mes' },
  { val: '2',     label: 'eventos/mes para $30K adicionales' },
  { val: '500',   label: 'usuarios Pro para $75K/mes' },
  { val: '$405K', label: 'MXN/mes total año 1 (objetivo)' },
]

export const nichoSports = [
  { emoji: '🏋️', title: 'CrossFit / WOD',     body: 'Matching por nivel RX, Scaled o Beginner. Eventos patrocinados por boxes.' },
  { emoji: '🤸', title: 'Calistenia',          body: 'Parques equipados de CDMX. Matching por habilidad: front lever, muscle-up, pistol squat.' },
  { emoji: '⚡', title: 'HIIT / Bootcamp',     body: 'Alta frecuencia semanal, ideal para comunidad recurrente. Intensidad como filtro.' },
  { emoji: '🎯', title: 'Kettlebell / Fuerza', body: 'Nicho pequeño pero muy comprometido. Usuarios Pro por naturaleza.' },
]

export const securityLayers = [
  { step: 1, label: 'Obligatorio',        title: 'Número de teléfono',          body: 'OTP por SMS o WhatsApp. Bloquea bots y cuentas múltiples. Es el mínimo para crear perfil. Sin esto, la app no existe para ti.', tag: '✓ Requerido para usar la app',           tagTone: 'req' },
  { step: 2, label: 'Obligatorio',        title: 'Foto real de perfil',         body: 'Foto frontal, no avatar. El algoritmo detecta si es selfie real vs imagen de internet. Revisión manual en casos dudosos. Se muestra siempre al compañero potencial.', tag: '✓ Requerido para publicar sesión', tagTone: 'req' },
  { step: 3, label: 'Verificación extra', title: 'INE / Identificación oficial', body: 'El usuario sube foto de su INE o pasaporte. OCR extrae nombre completo y CURP. Se valida contra el padrón del INE (API pública del INE). No se almacena la imagen — solo el resultado: "verificado ✓" con nombre inicial.', tag: '★ Diferenciador clave de seguridad', tagTone: 'new', primary: true },
  { step: 4, label: 'Progresivo',         title: 'Rating post-sesión',          body: 'Después de cada sesión, ambos participantes se califican. El rating se construye con el tiempo — usuarios nuevos tienen menos visibilidad hasta acumular reputación.', tag: 'Opcional — aumenta visibilidad', tagTone: 'opt' },
  { step: 5, label: 'Contextual',         title: 'Modo "Solo Mujeres"',         body: 'Las usuarias pueden activar que solo reciban y aparezcan en matches con otras mujeres. Verificación INE obligatoria para acceder a este modo.', tag: 'Toggle en perfil — verificación INE requerida', tagTone: 'opt' },
  { step: 6, label: 'Protección',         title: 'Chat antes de revelar ubicación', body: 'La ubicación exacta del punto de encuentro solo se revela cuando ambas partes confirman via chat in-app. Hasta ese momento, solo se muestra zona general (ej. "Roma Norte").', tag: '✓ Por diseño — no modificable', tagTone: 'req' },
]

export const ineFlow = [
  { num: '01', label: 'Captura',         body: 'El usuario fotografía frente y reverso de su INE o pasaporte desde la app. Guía visual que asegura buena calidad de imagen.' },
  { num: '02', label: 'OCR + Extracción', body: 'OCR extrae nombre completo, CURP y clave de elector. Se puede usar AWS Textract o Google Vision con modelo entrenado para INE.' },
  { num: '03', label: 'Validación INE',  body: 'Se consulta el servicio de verificación del INE o CURP via RENAPO/CURP API del gobierno. Confirma que los datos son válidos y reales.' },
  { num: '04', label: 'Badge + Borrado', body: 'Se asigna badge "Verificado INE ✓" al perfil. La imagen de la INE se borra inmediatamente. Solo se guarda el resultado: nombre, inicial y estado de verificación.' },
]

export const ineNotes = [
  { icon: '🔒', tone: 'green',  title: 'Privacidad por diseño',     body: 'Nunca se almacena la imagen del INE en servidores propios. Se procesa en tránsito y se elimina. Solo el resultado booleano persiste.' },
  { icon: '⚡', tone: 'amber',  title: 'Tiempo de verificación',    body: '30-90 segundos en condiciones normales. Si la API del INE falla, el usuario queda en estado "Pendiente de verificación" con acceso limitado.' },
  { icon: '📋', tone: 'teal',   title: 'Marco legal',                body: 'Requiere aviso de privacidad conforme a la LFPDPPP. El usuario consiente explícitamente el uso de sus datos para este único fin. Se puede usar proveedor como Metamap o Truora.' },
  { icon: '🛡️', tone: 'red',   title: 'Qué pasa si alguien falla', body: 'No puede usar el Modo Solo Mujeres. No puede publicar en zonas con alta demanda. Su perfil muestra "Sin verificación de identidad" — visible para otros.' },
]

export const trustPillars = [
  { icon: '🆔', tone: 'teal',  title: 'Identidad verificable', body: 'Teléfono + foto real + INE crea una tríada de identidad que hace extremadamente difícil operar de forma anónima con malas intenciones. El costo de crear una cuenta falsa es muy alto.', tags: ['OTP SMS', 'Foto selfie', 'INE + CURP'] },
  { icon: '⭐', tone: 'green', title: 'Reputación acumulada',  body: 'El sistema de ratings es el sistema inmune de la comunidad. Un usuario con 50 sesiones y rating 4.8 es auto-moderado por la comunidad. Los usuarios nuevos tienen menor visibilidad — incentiva el buen comportamiento desde el primer día.', tags: ['Rating post-sesión', 'Historial público', 'Badges de antigüedad'] },
  { icon: '💬', tone: 'amber', title: 'Revelación progresiva', body: 'La ubicación exacta es lo más sensible. El flujo de información es escalonado: zona general → chat → confirmación mutua → punto exacto. Nadie conoce tu dirección de salida si no hay confirmación de ambas partes.', tags: ['Chat in-app primero', 'Zona general → exacta', 'Confirmación mutua'] },
  { icon: '🚨', tone: 'ink',   title: 'Reporte y consecuencias', body: 'Sistema de reporte en 2 taps disponible durante y después de la sesión. Tres reportes = revisión manual inmediata. Un reporte validado = suspensión. Las consecuencias son visibles — actúa como disuasivo efectivo.', tags: ['Reporte en 2 taps', 'Revisión en 24h', 'Suspensión inmediata'] },
]

export const ratingCriteria = [
  { label: 'Puntualidad',    body: '¿Llegó a tiempo? El "no show" sin aviso es la principal causa de abandono del producto. Se pondera x1.5 en el score.' },
  { label: 'Nivel declarado', body: '¿El nivel (pace, intensidad) correspondió al perfil? Calibra automáticamente el matching futuro de esa persona.' },
  { label: 'Respeto y trato', body: '¿Se sintió una experiencia segura y respetuosa? Este criterio activa revisión manual si es consistentemente bajo.' },
]

export const chatPreview = {
  name: 'Mariana V.',
  initials: 'MV',
  verified: '✓ Verificada INE · ★ 4.9 · 23 sesiones',
  zone: 'Roma Norte',
  bubbles: [
    { from: 'them', av: 'MV', text: 'Hola! Vi tu sesión de running mañana 7am. Yo corro pace 5:45, ¿está bien con tu nivel?' },
    { from: 'me',   av: 'Tú', text: 'Sí, perfecto! Normalmente salgo por Álvaro Obregón. ¿Tú de qué zona?' },
    { from: 'them', av: 'MV', text: 'De Tamaulipas casi Sonora. Podemos quedar en Parque México que está a mitad 🏃‍♀️' },
  ],
}

export const summaryRows = [
  { title: 'Teléfono + OTP',           sub: 'Verificación básica de persona real',           status: 'req', statusLabel: 'Requerido',      impact: 3, applies: 'Todos los usuarios' },
  { title: 'Foto de perfil real',      sub: 'Selfie frontal, no avatar',                     status: 'req', statusLabel: 'Requerido',      impact: 4, applies: 'Para publicar sesión' },
  { title: 'Verificación INE / CURP',  sub: 'Identidad oficial confirmada',                  status: 'new', statusLabel: '★ Nuevo',         impact: 5, applies: 'Modo mujeres + zonas premium' },
  { title: 'Rating post-sesión',       sub: 'Reputación acumulada por la comunidad',         status: 'opt', statusLabel: 'Progresivo',     impact: 5, applies: 'Todos los usuarios post-sesión' },
  { title: 'Modo Solo Mujeres',        sub: 'Sesiones exclusivas verificadas',                status: 'opt', statusLabel: 'Opcional',       impact: 5, applies: 'Usuarias con INE verificada' },
  { title: 'Chat antes de ubicación',  sub: 'Revelación progresiva del punto de encuentro',  status: 'req', statusLabel: 'Requerido',      impact: 4, applies: 'Toda sesión con desconocido' },
  { title: 'Sistema de reportes',      sub: 'Moderación comunitaria + manual',               status: 'req', statusLabel: 'Siempre activo', impact: 3, applies: 'Todos los usuarios' },
]

// Map pins (mockup screen 1)
export const mapPins = [
  { id: 'crossfit-wod',  emoji: '🏋️', label: 'CrossFit WOD', tone: 'teal',  x: 41, y: 37 },
  { id: 'calistenia',    emoji: '🤸', label: 'Calistenia',   tone: 'volt',  x: 75, y: 45 },
  { id: 'box-alpha-pin', emoji: '🏆', label: 'Evento Box Alpha', tone: 'event', badge: '!', x: 55, y: 69 },
  { id: 'hiit-pin',      emoji: '⚡', label: 'HIIT',         tone: 'ink',   x: 19, y: 62 },
  { id: 'running-pin',   emoji: '🏃', label: 'Running',      tone: 'teal',  x: 89, y: 80 },
]
