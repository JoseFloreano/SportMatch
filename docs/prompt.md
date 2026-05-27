Tengo dos HTML mockups de una app llamada SportMatch (app de matching deportivo hiperlocal, tipo Google Maps para encontrar compañeros de ejercicio en CDMX). Necesito que los conviertas en un proyecto React con JSX.

## Archivos fuente

Los dos HTML están en:

- ./sportmatch_mockup.html → pantallas de la app (mapa, publicar sesión, evento patrocinado, perfil)
- ./sportmatch_seguridad.html → documento de plan: modelo de negocio, nicho, seguridad

Lee ambos archivos antes de escribir una sola línea de código.

## Lo que debes crear

Inicializa un proyecto React con Vite:
npm create vite@latest sportmatch -- --template react
cd sportmatch && npm install

Instala dependencias adicionales:
npm install react-router-dom tailwindcss @tailwindcss/vite lucide-react

Configura Tailwind v4 con el plugin de Vite (vite.config.js + import en index.css).

## Estructura de carpetas

src/
components/
ui/ → componentes reutilizables (Badge, Button, Toggle, Chip, Card, Avatar, BottomTab)
map/ → MapArea, MapPin, UserDot, MapControls
session/ → SessionCard, SessionFeed
event/ → EventCard, EventDetail, WodBlock, LevelAvailability
profile/ → ProfileHero, ProfileStats, SportPrefs, ScheduleGrid
publish/ → PublishForm, SportSelector, LevelSelector
plan/ → BusinessModel, RevenueStream, NichoBlock, SecuritySection, IneFlow
pages/
MapPage.jsx → pantalla 1: mapa + feed
PublishPage.jsx → pantalla 2: publicar sesión
EventDetailPage.jsx → pantalla 3: evento patrocinado
ProfilePage.jsx → pantalla 4: perfil verificado
PlanPage.jsx → documento completo del plan (del segundo HTML)
App.jsx → router con react-router-dom
index.css → tokens CSS + Tailwind
main.jsx

## Sistema de diseño — tokens a respetar (extraídos del HTML)

Crea un archivo src/tokens.js con estas variables (úsalas como clases Tailwind custom o CSS vars):

volt: #C8FF00 (acento principal)
volt-dark: #9DCA00
ink: #0E1117 (negro deportivo)
ink-mid: #2A2F3A
slate: #4A5260
mist: #EEF0F4
teal: #00B4A0
amber: #F5A623
red: #E8393A
green: #27AE60
border: #DDE1E8

Tipografía:
display → 'Barlow Condensed' (800, 700, 600) — headings, labels, números grandes
body → 'Barlow' (400, 500, 600) — texto corrido

Agrega el import de Google Fonts en index.html:
https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800&family=Barlow:wght@400;500;600&display=swap

## Componentes UI base — comportamiento esperado

Button: variantes ink (fondo oscuro + texto volt), volt (fondo volt + texto ink), mist (fondo gris), amber. Props: variant, size (sm/md/lg), fullWidth, onClick.

Badge: variantes ine (volt sobre ink), phone (teal), event (amber), women (purple), req (ink), opt (mist), new (volt). Siempre con ícono + texto.

Toggle: controlled component. Props: value (bool), onChange. Animación CSS slide. Cuando on: thumb volt sobre ink. Cuando off: thumb blanco sobre border.

Chip: variante default y active (ink + volt). Props: label, emoji, active, onClick.

Card: base card con border 1px solid border-color, radius-lg, fondo white. Variantes: default, event (amber border), women (purple border), ink (fondo ink).

SessionCard: recibe { sport, emoji, userName, rating, zone, distance, time, date, level, spots, isEvent, isWomenOnly, isVerified }. Muestra badges INE, "Solo mujeres", nivel, spots. Botón "Unirse" o "Ver →" si isEvent.

## Pantallas — comportamiento

MapPage:

- Área de mapa simulada con SVG (calles como líneas y rectángulos, colores de la paleta). No integres Leaflet ni Mapbox aún — el mapa es decorativo/estático por ahora con pins posicionados con CSS absolute.
- Filtros horizontales scrolleables (chips). Al hacer click en un chip se filtra el SessionFeed por deporte.
- SessionFeed debajo del mapa con las sesiones del mock.
- FAB "+" que navega a /publish.
- BottomTab con 4 ítems: Mapa (/), Eventos (/events), Chats (/chats), Perfil (/profile).

PublishPage:

- SportSelector: grid 3x2, selección single, highlight ink+volt en el seleccionado.
- FieldRow para día, hora y zona (inputs o selects básicos por ahora).
- LevelSelector: RX (red), Scaled (amber), Beginner (green) — borde + fondo en color del nivel seleccionado.
- Dos toggles: "Solo mujeres" y "Notificar por WhatsApp".
- Botón "Publicar en el mapa" → navega back a /.

EventDetailPage:

- Header oscuro (ink) con badge "Evento patrocinado".
- EventStats: 3 métricas (cupos, spots libres, costo).
- GymCard: logo emoji + nombre + dirección + badge verificado.
- WodBlock: lista de ejercicios con cantidad, nombre y nota de nivel.
- LevelAvailability: 3 pills RX/Scaled/Beginner con spots disponibles.
- Dos botones: "Inscribirme" (amber) y "Chat con asistentes" (mist).

ProfilePage:

- ProfileHero con fondo ink, avatar con iniciales, badges INE + Teléfono, nombre, rating con estrellas.
- ProfileStats: sesiones, asistencia%, eventos.
- SportPrefs: chips con deporte + nivel, el primero marcado como primary.
- ScheduleGrid: días de la semana, los activos con punto volt sobre fondo ink.
- WomenToggle: fila con ícono ♀, título, subtítulo y Toggle controlled.

PlanPage:

- Replica el HTML del plan en componentes React.
- Secciones: BusinessModel → 4 RevenueStream cards → NichoBlock → SecuritySection → IneFlow → SecurityLayers → RatingsSection → WomenMode → ChatPreview → SummaryTable.
- No es una pantalla de móvil — es una página web de documento (max-width: 900px, centered).

## Data mock

Crea src/data/mockData.js con los datos que aparecen en los HTMLs:

- sessions: array con las 3 sesiones del feed (CrossFit, WOD Matutino, Calistenia)
- events: array con el evento Box Alpha
- userProfile: objeto Mariana Valdés
- revenueStreams: array con las 4 fuentes de ingreso
- securityLayers: array con las 6 capas de verificación
- nichoSports: array con los 4 deportes funcionales

## Estilo — reglas estrictas

- Sin librerías de componentes (no MUI, no Chakra, no shadcn). Solo Tailwind + CSS custom.
- Usa CSS variables (--volt, --ink, etc.) definidas en :root de index.css. Tailwind puede referenciarlas con var(--volt).
- Los colores custom van en tailwind.config.js bajo theme.extend.colors.
- Barlow Condensed para todo texto en mayúsculas (headings, labels, números). Barlow regular para body.
- Todos los textos en mayúsculas que estaban en uppercase en el HTML deben seguir en uppercase con font-family Barlow Condensed.
- La paleta ink/volt/teal debe mantenerse exactamente — no sustituyas por colores Tailwind default.
- border-radius: usa rounded-xl (12px) para cards internas, rounded-2xl (20px) para cards principales, rounded-3xl (28px) para modales y bloques hero.

## Entregable final

Al terminar:

1. El proyecto debe correr con `npm run dev` sin errores.
2. Todas las rutas deben funcionar: /, /publish, /events/:id, /profile, /plan.
3. El filtrado de chips en MapPage debe funcionar en el cliente.
4. Los toggles deben ser functional (useState).
5. La selección de deporte y nivel en PublishPage debe ser functional (useState).
6. Dame un resumen de los componentes creados y cualquier decisión de arquitectura que hayas tomado.
