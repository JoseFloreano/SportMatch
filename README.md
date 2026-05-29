# SportMatch

App móvil (Flutter) para coordinar sesiones de deporte funcional (CrossFit, calistenia, HIIT)
entre personas compatibles en CDMX. Mapa tipo Google Maps con sesiones cercanas, publicación de
sesiones, perfiles verificados y (en Sprint 2) notificaciones por WhatsApp, eventos patrocinados,
chat y ratings.

> Monorepo: este directorio contiene la app **Flutter** (raíz: `lib/`, `android/`, `ios/`).
> El prototipo web en React vive en [`frontend_web/`](frontend_web/) y los mockups/plan en [`docs/`](docs/).

## Stack

- **Flutter** (iOS + Android) · Riverpod (codegen) · GoRouter
- **Supabase**: PostgreSQL + PostGIS + Auth (OTP SMS) + Realtime + Edge Functions
- **Mapa**: `flutter_map` + OpenStreetMap (MVP sin API key)
- **Ubicación**: `geolocator` + `geocoding`
- Tipografía: Barlow / Barlow Condensed (`google_fonts`)

## Setup en 5 pasos

1. **Clona e instala dependencias**
   ```bash
   flutter pub get
   ```

2. **Crea tu proyecto Supabase** en [supabase.com](https://supabase.com) y copia las credenciales.

3. **Configura el entorno**: copia el ejemplo y llena los valores reales.
   ```bash
   cp .env.example .env
   # edita .env con SUPABASE_URL y SUPABASE_ANON_KEY (mínimo)
   ```
   El `.env` está en `.gitignore`. Las variables se leen en compile-time vía `--dart-define-from-file`.

4. **Ejecuta el esquema SQL**: en Supabase Dashboard → SQL Editor, pega y corre
   [`supabase/migrations/001_initial_schema.sql`](supabase/migrations/001_initial_schema.sql).
   - Habilita el proveedor **Phone** en Authentication → Providers (con tu proveedor SMS, ej. Twilio).
   - Crea un bucket público **`avatars`** en Storage (para fotos de perfil).

5. **Corre la app**
   ```bash
   flutter run --dart-define-from-file=.env
   ```

## Generación de código (Riverpod)

Los providers usan `riverpod_generator`. Tras clonar o cambiar un provider/anotación, regenera:

```bash
dart run build_runner build --delete-conflicting-outputs
# o en modo watch durante desarrollo:
dart run build_runner watch --delete-conflicting-outputs
```

## Comandos útiles

```bash
flutter analyze                                   # 0 errores esperados
flutter test                                      # tests unitarios
flutter run --dart-define-from-file=.env          # correr en el dispositivo conectado
flutter run --dart-define-from-file=.env -d <id>  # elegir dispositivo (flutter devices)
```

## Variables de entorno

Ver [`.env.example`](.env.example). Mínimas para arrancar: `SUPABASE_URL`, `SUPABASE_ANON_KEY`.
Las de WhatsApp / Google Maps se usan en el Sprint 2.

## Arquitectura

```
lib/
  core/          constantes (colores, tipografía), env, router, utils (ubicación, fechas)
  data/          models · repositories (Supabase) · providers (clientes + repos)
  features/      auth · map · sessions · events · profile · chat · ratings
                 cada feature: pages/ · widgets/ · providers/
  shared/        widgets reutilizables (Button, Badge, Card, BottomNav, LoadingOverlay)
supabase/
  migrations/    esquema SQL (PostGIS, RLS, triggers, RPC geoespacial)
  functions/     Edge Functions (Sprint 2: WhatsApp, matching, ratings)
```

- **Patrón de capas**: UI (pages/widgets) → providers (Riverpod) → repositories → Supabase SDK.
  La lógica de negocio vive en repositories/providers, nunca en las páginas.
- **Geoespacial**: las sesiones guardan `location GEOGRAPHY(POINT)` + `lat/lng`. La función
  `get_nearby_sessions` usa `ST_DWithin` para buscar por radio.

## Estado de los sprints

- **Sprint 1 (este entregable)**: backend SQL, auth OTP, mapa con ubicación real, CRUD de sesiones,
  perfil. Páginas de detalle de sesión/evento en modo lectura.
- **Sprint 2 (pendiente)**: Edge Functions de WhatsApp, matching, eventos con inscripción,
  chat en tiempo real, ratings post-sesión. Stubs ya presentes en `features/chat` y `features/ratings`.
