# Prompt para Claude Code — SportMatch

## Flutter + Supabase Backend · 2 Sprints

## Contexto del proyecto

Estás construyendo **SportMatch**: una app móvil Flutter para coordinar sesiones de deporte funcional (CrossFit, calistenia, HIIT) entre desconocidos en CDMX. Los usuarios publican sesiones con ubicación y horario en un mapa tipo Google Maps, otros se unen, y ambos reciben notificaciones por WhatsApp.

**Stack definido:**

- Frontend: Flutter (iOS + Android)
- Backend/BaaS: Supabase (PostgreSQL + PostGIS + Realtime + Auth + Edge Functions)
- Mapa: `flutter_map` + OpenStreetMap (MVP sin costo)
- Ubicación: `geolocator` + `geocoding`
- Notificaciones: Meta WhatsApp Cloud API vía Supabase Edge Functions
- Estado en Flutter: Riverpod

**Antes de empezar:** Lee los archivos de contexto si existen en el directorio:

- `sportmatch_backend_analisis.md` — arquitectura, esquema SQL, flujos
- `sportmatch_mockup.html` — diseño visual de referencia

---

# SPRINT 1 — Backend Supabase + App Shell Flutter funcional

**Objetivo:** App que corre en simulador, autenticación funcionando, mapa con ubicación real del usuario, CRUD de sesiones completo con datos reales de Supabase.

---

## PASO 1 — Crear el proyecto Flutter

```bash
flutter create sportmatch --org com.sportmatch --platforms ios,android
cd sportmatch
```

Crea la siguiente estructura de directorios completa antes de escribir código:

```
SportMatch/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   └── app_constants.dart
│   │   ├── env/
│   │   │   └── env.dart               ← variables de entorno via --dart-define
│   │   ├── router/
│   │   │   └── app_router.dart         ← GoRouter
│   │   └── utils/
│   │       ├── location_service.dart
│   │       └── date_formatter.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── profile_model.dart
│   │   │   ├── session_model.dart
│   │   │   ├── event_model.dart
│   │   │   ├── rating_model.dart
│   │   │   └── message_model.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── session_repository.dart
│   │   │   ├── event_repository.dart
│   │   │   ├── profile_repository.dart
│   │   │   └── rating_repository.dart
│   │   └── providers/
│   │       └── supabase_provider.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── pages/
│   │   │   │   ├── phone_input_page.dart
│   │   │   │   └── otp_verify_page.dart
│   │   │   └── providers/
│   │   │       └── auth_provider.dart
│   │   ├── map/
│   │   │   ├── pages/
│   │   │   │   └── map_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── session_pin.dart
│   │   │   │   ├── event_pin.dart
│   │   │   │   └── session_bottom_sheet.dart
│   │   │   └── providers/
│   │   │       └── map_provider.dart
│   │   ├── sessions/
│   │   │   ├── pages/
│   │   │   │   ├── publish_page.dart
│   │   │   │   └── session_detail_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── session_card.dart
│   │   │   │   ├── sport_selector.dart
│   │   │   │   └── level_selector.dart
│   │   │   └── providers/
│   │   │       └── session_provider.dart
│   │   ├── events/
│   │   │   ├── pages/
│   │   │   │   └── event_detail_page.dart
│   │   │   └── providers/
│   │   │       └── event_provider.dart
│   │   ├── profile/
│   │   │   ├── pages/
│   │   │   │   ├── profile_page.dart
│   │   │   │   └── edit_profile_page.dart
│   │   │   └── providers/
│   │   │       └── profile_provider.dart
│   │   ├── chat/
│   │   │   ├── pages/
│   │   │   │   └── chat_page.dart
│   │   │   └── providers/
│   │   │       └── chat_provider.dart
│   │   └── ratings/
│   │       ├── pages/
│   │       │   └── rating_page.dart
│   │       └── providers/
│   │           └── rating_provider.dart
│   └── shared/
│       └── widgets/
│           ├── sport_match_button.dart
│           ├── sport_match_badge.dart
│           ├── sport_match_card.dart
│           ├── bottom_nav_bar.dart
│           └── loading_overlay.dart
├── supabase/
│   ├── migrations/
│   │   └── 001_initial_schema.sql
│   └── functions/
│       ├── notify-whatsapp/
│       │   └── index.ts
│       ├── match-users/
│       │   └── index.ts
│       └── request-ratings/
│           └── index.ts
├── .env.example
├── pubspec.yaml
└── README.md
```

---

## PASO 2 — Crear `.env.example`

Crea el archivo `.env.example` en la raíz del proyecto con EXACTAMENTE este contenido:

```env
# ─────────────────────────────────────────────────────────
# SportMatch — Variables de entorno
# Copia este archivo como .env y llena los valores reales.
# NUNCA subas .env a git. Ya está en .gitignore.
# ─────────────────────────────────────────────────────────

# ── SUPABASE ──────────────────────────────────────────────
# Obtén estos valores en: supabase.com → Tu proyecto → Settings → API
SUPABASE_URL=https://xxxxxxxxxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xxxx

# ── WHATSAPP CLOUD API (Meta) ─────────────────────────────
# Obtén estos en: developers.facebook.com → Tu App → WhatsApp → API Setup
# El PHONE_NUMBER_ID es el ID numérico del número de WhatsApp Business
# El TOKEN es el System User Token (permanente, no el temporal de pruebas)
WHATSAPP_TOKEN=EAAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
WHATSAPP_PHONE_NUMBER_ID=123456789012345
WHATSAPP_API_VERSION=v19.0
# Número de WhatsApp del negocio (formato internacional sin +)
WHATSAPP_BUSINESS_NUMBER=521XXXXXXXXXX

# ── MAPA ──────────────────────────────────────────────────
# MVP: flutter_map usa OpenStreetMap, no necesita API key.
# Para migrar a Google Maps en el futuro, obtén la key en:
# console.cloud.google.com → APIs & Services → Credentials
# Habilitar: Maps SDK for Android, Maps SDK for iOS, Places API
GOOGLE_MAPS_API_KEY=AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# ── CONFIGURACIÓN DE LA APP ───────────────────────────────
# Radio por default para buscar sesiones cercanas (en kilómetros)
DEFAULT_SEARCH_RADIUS_KM=3.0
# Horas antes de la sesión para enviar recordatorio WhatsApp
REMINDER_HOURS_BEFORE=1
# Horas después de la sesión para solicitar rating
RATING_REQUEST_HOURS_AFTER=2
# Ambiente: development | staging | production
APP_ENV=development

# ── FIREBASE (push notifications fallback) ────────────────
# Descarga google-services.json (Android) y GoogleService-Info.plist (iOS)
# desde console.firebase.google.com y colócalos en las rutas correctas.
# Las variables directas no se usan, la config va en los archivos nativos.
# android/app/google-services.json
# ios/Runner/GoogleService-Info.plist
FIREBASE_PROJECT_ID=sportmatch-app
```

Agrega `.env` al `.gitignore` si no está:

```
echo "\n# Environment\n.env\n*.env.local" >> .gitignore
```

**Nota sobre cómo se leen las variables en Flutter:**
Las variables de entorno se pasan en tiempo de compilación via `--dart-define-from-file=.env`. NO uses `dotenv` packages en runtime — es menos seguro. Crea `lib/core/env/env.dart`:

```dart
// lib/core/env/env.dart
// Las variables se inyectan en compile time con:
// flutter run --dart-define-from-file=.env
// flutter build apk --dart-define-from-file=.env

abstract class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );
  static const whatsappToken = String.fromEnvironment(
    'WHATSAPP_TOKEN',
    defaultValue: '',
  );
  static const whatsappPhoneNumberId = String.fromEnvironment(
    'WHATSAPP_PHONE_NUMBER_ID',
    defaultValue: '',
  );
  static const whatsappApiVersion = String.fromEnvironment(
    'WHATSAPP_API_VERSION',
    defaultValue: 'v19.0',
  );
  static const googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );
  static const defaultSearchRadiusKm = double.fromEnvironment(
    'DEFAULT_SEARCH_RADIUS_KM',
    defaultValue: 3.0,
  );
  static const reminderHoursBefore = int.fromEnvironment(
    'REMINDER_HOURS_BEFORE',
    defaultValue: 1,
  );
  static const ratingRequestHoursAfter = int.fromEnvironment(
    'RATING_REQUEST_HOURS_AFTER',
    defaultValue: 2,
  );
  static const appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction => appEnv == 'production';

  static void validate() {
    assert(supabaseUrl.isNotEmpty, 'SUPABASE_URL no está definida en .env');
    assert(supabaseAnonKey.isNotEmpty, 'SUPABASE_ANON_KEY no está definida en .env');
  }
}
```

---

## PASO 3 — `pubspec.yaml` completo

Escribe el `pubspec.yaml` con EXACTAMENTE estas dependencias (versiones fijas para reproducibilidad):

```yaml
name: sportmatch
description: Coordina sesiones deportivas con personas compatibles en tu zona.
version: 1.0.0+1
publish_to: none

environment:
  sdk: ">=3.3.0 <4.0.0"
  flutter: ">=3.22.0"

dependencies:
  flutter:
    sdk: flutter

  # ── Backend ─────────────────────────────────────────────
  supabase_flutter: ^2.5.6 # Supabase SDK completo (auth + db + realtime + functions)

  # ── Estado (State Management) ────────────────────────────
  flutter_riverpod: ^2.5.1 # Provider de estado
  riverpod_annotation: ^2.3.5 # Anotaciones para code gen (opcional pero útil)

  # ── Navegación ───────────────────────────────────────────
  go_router: ^14.2.7 # Router declarativo

  # ── Mapa ─────────────────────────────────────────────────
  flutter_map: ^7.0.2 # Mapa OpenStreetMap (MVP sin costo)
  latlong2: ^0.9.1 # Coordenadas lat/lng
  flutter_map_marker_cluster: ^1.3.2 # Agrupa pins cercanos

  # ── Ubicación ────────────────────────────────────────────
  geolocator: ^13.0.3 # GPS y permisos
  geocoding: ^3.0.0 # Coordenadas → nombre de lugar

  # ── UI ───────────────────────────────────────────────────
  google_fonts: ^6.2.1 # Barlow + Barlow Condensed
  cached_network_image: ^3.4.1 # Imágenes con caché (avatares)
  shimmer: ^3.0.0 # Loading skeleton
  modal_bottom_sheet: ^3.0.0 # Bottom sheets para sesiones
  intl: ^0.19.0 # Formateo de fechas en español

  # ── Utilidades ───────────────────────────────────────────
  uuid: ^4.4.0 # Generar UUIDs
  url_launcher: ^6.3.0 # Abrir WhatsApp externo (fallback)
  share_plus: ^10.0.0 # Compartir sesión
  image_picker: ^1.1.2 # Avatar del perfil

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

Crea los directorios de assets:

```bash
mkdir -p assets/images assets/icons
```

---

## PASO 4 — Sistema de diseño (tokens)

### `lib/core/constants/app_colors.dart`

```dart
import 'package:flutter/material.dart';

abstract class AppColors {
  // Paleta principal SportMatch
  static const volt      = Color(0xFFC8FF00);  // Verde eléctrico — acento principal
  static const voltDark  = Color(0xFF9DCA00);  // Verde acento oscuro
  static const ink       = Color(0xFF0E1117);  // Negro deportivo
  static const inkMid    = Color(0xFF2A2F3A);
  static const slate     = Color(0xFF4A5260);
  static const mist      = Color(0xFFEEF0F4);  // Fondo de cards
  static const white     = Color(0xFFFFFFFF);
  static const teal      = Color(0xFF00B4A0);  // Verificado
  static const tealLight = Color(0xFFE0F7F5);
  static const red       = Color(0xFFE8393A);  // Alertas / RX level
  static const redLight  = Color(0xFFFEF0F0);
  static const amber     = Color(0xFFF5A623);  // Eventos patrocinados
  static const amberLight= Color(0xFFFEF6E7);
  static const green     = Color(0xFF27AE60);  // Beginner / éxito
  static const greenLight= Color(0xFFE8F8EE);
  static const purple    = Color(0xFF7C3AED);  // Modo solo mujeres
  static const purpleLight= Color(0xFFF0EAFF);
  static const border    = Color(0xFFDDE1E8);

  // Semánticos
  static const levelRx       = red;
  static const levelScaled   = amber;
  static const levelBeginner = green;
  static const eventColor    = amber;
  static const womenMode     = purple;
  static const verified      = teal;

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ink,
      primary: ink,
      secondary: volt,
      surface: white,
      error: red,
    ),
    scaffoldBackgroundColor: mist,
  );
}
```

### `lib/core/constants/app_text_styles.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // Barlow Condensed — headings, labels, números grandes, uppercase
  static TextStyle headline1 = GoogleFonts.barlowCondensed(
    fontSize: 48, fontWeight: FontWeight.w800,
    color: AppColors.ink, letterSpacing: -0.5,
  );
  static TextStyle headline2 = GoogleFonts.barlowCondensed(
    fontSize: 32, fontWeight: FontWeight.w800,
    color: AppColors.ink, letterSpacing: -0.3,
  );
  static TextStyle headline3 = GoogleFonts.barlowCondensed(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.ink, textBaseline: TextBaseline.alphabetic,
  );
  static TextStyle label = GoogleFonts.barlowCondensed(
    fontSize: 12, fontWeight: FontWeight.w700,
    color: AppColors.slate, letterSpacing: 0.1,
  );
  static TextStyle labelUppercase = GoogleFonts.barlowCondensed(
    fontSize: 11, fontWeight: FontWeight.w700,
    color: AppColors.slate, letterSpacing: 0.12,
  );
  static TextStyle sportTag = GoogleFonts.barlowCondensed(
    fontSize: 14, fontWeight: FontWeight.w700,
    color: AppColors.ink, letterSpacing: 0.05,
  );
  static TextStyle bigNumber = GoogleFonts.barlowCondensed(
    fontSize: 28, fontWeight: FontWeight.w800,
    color: AppColors.ink, height: 1.0,
  );
  static TextStyle time = GoogleFonts.barlowCondensed(
    fontSize: 20, fontWeight: FontWeight.w800,
    color: AppColors.ink, height: 1.0,
  );

  // Barlow — texto corrido, body, subtítulos
  static TextStyle body = GoogleFonts.barlow(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.slate, height: 1.6,
  );
  static TextStyle bodyMedium = GoogleFonts.barlow(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );
  static TextStyle bodySmall = GoogleFonts.barlow(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.slate, height: 1.5,
  );
  static TextStyle button = GoogleFonts.barlowCondensed(
    fontSize: 15, fontWeight: FontWeight.w800,
    letterSpacing: 0.08,
  );
}
```

### `lib/core/constants/app_constants.dart`

```dart
abstract class AppConstants {
  // Deportes disponibles (nicho funcional primero)
  static const List<Map<String, String>> sports = [
    {'id': 'crossfit',   'label': 'CrossFit',   'emoji': '🏋️'},
    {'id': 'calistenia', 'label': 'Calistenia', 'emoji': '🤸'},
    {'id': 'hiit',       'label': 'HIIT',       'emoji': '⚡'},
    {'id': 'kettlebell', 'label': 'Kettlebell', 'emoji': '🎯'},
    {'id': 'running',    'label': 'Running',    'emoji': '🏃'},
    {'id': 'tenis',      'label': 'Tenis',      'emoji': '🎾'},
    {'id': 'yoga',       'label': 'Yoga',       'emoji': '🧘'},
    {'id': 'futbol',     'label': 'Fútbol',     'emoji': '⚽'},
  ];

  // Niveles de deporte funcional
  static const List<Map<String, String>> levels = [
    {'id': 'rx',       'label': 'RX',       'desc': 'Competitivo'},
    {'id': 'scaled',   'label': 'Scaled',   'desc': 'Intermedio'},
    {'id': 'beginner', 'label': 'Beginner', 'desc': 'Iniciando'},
    {'id': 'any',      'label': 'Todos',    'desc': 'Cualquier nivel'},
  ];

  // Centro del mapa por default: La Condesa, CDMX
  static const double defaultLat = 19.4116;
  static const double defaultLng = -99.1751;
  static const double defaultZoom = 15.0;

  // Horas para disparar recordatorio y rating
  static const int reminderHoursBefore = 1;
  static const int ratingHoursAfter = 2;
  static const int maxSpotsPerSession = 8;

  // WA phone format México
  static String formatMxPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('52')) return cleaned;
    if (cleaned.startsWith('1')) return '52$cleaned';
    return '521$cleaned'; // Agrega lada internacional
  }
}
```

---

## PASO 5 — Modelos de datos

### `lib/data/models/profile_model.dart`

```dart
class ProfileModel {
  final String id;
  final String displayName;
  final String phone;
  final String? avatarUrl;
  final String? bio;
  final String? neighborhood;
  final List<String> sports;
  final String? level;           // "rx" | "scaled" | "beginner"
  final bool womenOnlyMode;
  final bool whatsappOptin;
  final double rating;
  final int totalSessions;
  final double attendanceRate;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    required this.displayName,
    required this.phone,
    this.avatarUrl,
    this.bio,
    this.neighborhood,
    this.sports = const [],
    this.level,
    this.womenOnlyMode = false,
    this.whatsappOptin = true,
    this.rating = 0.0,
    this.totalSessions = 0,
    this.attendanceRate = 100.0,
    required this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) => ProfileModel(
    id: map['id'] as String,
    displayName: map['display_name'] as String,
    phone: map['phone'] as String,
    avatarUrl: map['avatar_url'] as String?,
    bio: map['bio'] as String?,
    neighborhood: map['neighborhood'] as String?,
    sports: List<String>.from(map['sports'] ?? []),
    level: map['level'] as String?,
    womenOnlyMode: map['women_only_mode'] as bool? ?? false,
    whatsappOptin: map['whatsapp_optin'] as bool? ?? true,
    rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
    totalSessions: map['total_sessions'] as int? ?? 0,
    attendanceRate: (map['attendance_rate'] as num?)?.toDouble() ?? 100.0,
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'display_name': displayName,
    'phone': phone,
    'avatar_url': avatarUrl,
    'bio': bio,
    'neighborhood': neighborhood,
    'sports': sports,
    'level': level,
    'women_only_mode': womenOnlyMode,
    'whatsapp_optin': whatsappOptin,
  };

  ProfileModel copyWith({
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? neighborhood,
    List<String>? sports,
    String? level,
    bool? womenOnlyMode,
    bool? whatsappOptin,
  }) => ProfileModel(
    id: id,
    displayName: displayName ?? this.displayName,
    phone: phone,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    bio: bio ?? this.bio,
    neighborhood: neighborhood ?? this.neighborhood,
    sports: sports ?? this.sports,
    level: level ?? this.level,
    womenOnlyMode: womenOnlyMode ?? this.womenOnlyMode,
    whatsappOptin: whatsappOptin ?? this.whatsappOptin,
    rating: rating,
    totalSessions: totalSessions,
    attendanceRate: attendanceRate,
    createdAt: createdAt,
  );
}
```

### `lib/data/models/session_model.dart`

```dart
class SessionModel {
  final String id;
  final String hostId;
  final String sport;
  final String level;
  final DateTime scheduledAt;
  final int durationMin;
  final int maxSpots;
  final int spotsAvailable;
  final String zoneName;
  final double lat;
  final double lng;
  final String? notes;
  final bool womenOnly;
  final String status;           // "open" | "full" | "confirmed" | "completed" | "cancelled"
  final ProfileModel? host;      // JOIN con profiles (nullable)
  final DateTime createdAt;

  const SessionModel({
    required this.id,
    required this.hostId,
    required this.sport,
    required this.level,
    required this.scheduledAt,
    this.durationMin = 60,
    required this.maxSpots,
    required this.spotsAvailable,
    required this.zoneName,
    required this.lat,
    required this.lng,
    this.notes,
    this.womenOnly = false,
    this.status = 'open',
    this.host,
    required this.createdAt,
  });

  bool get isFull => spotsAvailable == 0;
  bool get isOpen => status == 'open';
  String get sportEmoji {
    const emojis = {
      'crossfit': '🏋️', 'calistenia': '🤸', 'hiit': '⚡',
      'kettlebell': '🎯', 'running': '🏃', 'tenis': '🎾',
      'yoga': '🧘', 'futbol': '⚽',
    };
    return emojis[sport] ?? '🏃';
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    // PostGIS retorna location como WKT: "POINT(-99.1630 19.4193)"
    // O como un mapa con lat/lng si lo parseamos en la DB function
    double lat = 0.0;
    double lng = 0.0;
    if (map['lat'] != null && map['lng'] != null) {
      lat = (map['lat'] as num).toDouble();
      lng = (map['lng'] as num).toDouble();
    }
    return SessionModel(
      id: map['id'] as String,
      hostId: map['host_id'] as String,
      sport: map['sport'] as String,
      level: map['level'] as String,
      scheduledAt: DateTime.parse(map['scheduled_at'] as String),
      durationMin: map['duration_min'] as int? ?? 60,
      maxSpots: map['max_spots'] as int,
      spotsAvailable: map['spots_available'] as int,
      zoneName: map['zone_name'] as String,
      lat: lat,
      lng: lng,
      notes: map['notes'] as String?,
      womenOnly: map['women_only'] as bool? ?? false,
      status: map['status'] as String? ?? 'open',
      host: map['host'] != null
          ? ProfileModel.fromMap(map['host'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
```

### `lib/data/models/event_model.dart`

Crea `EventModel` con los campos: `id, sponsorId, title, sport, description, lat, lng, venueName, venueAddress, scheduledAt, durationMin, maxCapacity, spotsRx, spotsScaled, spotsBeginner, priceMxn, wodDescription (List<Map>), isSponsored, status, createdAt`. Incluye método `fromMap` y `toMap` con la misma lógica de parsing que SessionModel.

### `lib/data/models/rating_model.dart`

Campos: `id, sessionId?, eventId?, raterId, ratedId, punctuality (1-5), levelAccuracy (1-5), respect (1-5), overall (calculado), comment?, createdAt`. `fromMap` y `toMap`.

### `lib/data/models/message_model.dart`

Campos: `id, chatId, senderId, content, sentAt`. `fromMap` y `toMap`. Incluye `ProfileModel? sender` para JOIN.

---

## PASO 6 — Supabase SQL Migration

Crea el archivo `supabase/migrations/001_initial_schema.sql` con el siguiente SQL completo. Ejecútalo en el SQL Editor de Supabase Dashboard:

```sql
-- ═══════════════════════════════════════════════════════════
-- SportMatch — Schema inicial
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- ═══════════════════════════════════════════════════════════

-- Extensiones
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── PROFILES ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name    TEXT NOT NULL DEFAULT '',
  phone           TEXT UNIQUE,
  avatar_url      TEXT,
  bio             TEXT,
  neighborhood    TEXT,
  sports          TEXT[]    DEFAULT '{}',
  level           TEXT      CHECK (level IN ('rx','scaled','beginner','any')),
  women_only_mode BOOLEAN   DEFAULT FALSE,
  whatsapp_optin  BOOLEAN   DEFAULT TRUE,
  rating          NUMERIC(3,2) DEFAULT 0.0,
  total_sessions  INT       DEFAULT 0,
  attendance_rate NUMERIC(5,2) DEFAULT 100.0,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-crear perfil vacío al registrarse
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, phone)
  VALUES (NEW.id, NEW.phone)
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ── SESSIONS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.sessions (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  host_id         UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  sport           TEXT NOT NULL,
  level           TEXT NOT NULL DEFAULT 'any'
                  CHECK (level IN ('rx','scaled','beginner','any')),
  scheduled_at    TIMESTAMPTZ NOT NULL,
  duration_min    INT DEFAULT 60,
  max_spots       INT NOT NULL DEFAULT 4 CHECK (max_spots BETWEEN 1 AND 20),
  spots_available INT NOT NULL DEFAULT 4,
  zone_name       TEXT NOT NULL,
  location        GEOGRAPHY(POINT,4326) NOT NULL,
  -- Almacenamos lat/lng por separado para facilitar queries sin PostGIS en cliente
  lat             DOUBLE PRECISION NOT NULL,
  lng             DOUBLE PRECISION NOT NULL,
  notes           TEXT,
  women_only      BOOLEAN DEFAULT FALSE,
  status          TEXT DEFAULT 'open'
                  CHECK (status IN ('open','full','confirmed','completed','cancelled')),
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS sessions_location_gist ON public.sessions USING GIST(location);
CREATE INDEX IF NOT EXISTS sessions_scheduled_idx ON public.sessions(scheduled_at);
CREATE INDEX IF NOT EXISTS sessions_status_idx ON public.sessions(status);
CREATE INDEX IF NOT EXISTS sessions_host_idx ON public.sessions(host_id);

-- ── SESSION PARTICIPANTS ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.session_participants (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id  UUID NOT NULL REFERENCES public.sessions(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  status      TEXT DEFAULT 'pending'
              CHECK (status IN ('pending','accepted','rejected','cancelled')),
  joined_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(session_id, user_id)
);

-- Trigger: decrementar spots y actualizar status de sesión
CREATE OR REPLACE FUNCTION public.update_session_spots()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT' AND NEW.status = 'accepted')
      OR (TG_OP = 'UPDATE' AND NEW.status = 'accepted' AND OLD.status != 'accepted') THEN
    UPDATE public.sessions
    SET
      spots_available = GREATEST(spots_available - 1, 0),
      status = CASE WHEN spots_available - 1 <= 0 THEN 'full' ELSE status END,
      updated_at = NOW()
    WHERE id = NEW.session_id;
  ELSIF TG_OP = 'UPDATE' AND NEW.status = 'cancelled' AND OLD.status = 'accepted' THEN
    UPDATE public.sessions
    SET
      spots_available = LEAST(spots_available + 1, max_spots),
      status = CASE WHEN status = 'full' THEN 'open' ELSE status END,
      updated_at = NOW()
    WHERE id = NEW.session_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER session_participants_spots
  AFTER INSERT OR UPDATE ON public.session_participants
  FOR EACH ROW EXECUTE FUNCTION public.update_session_spots();

-- ── EVENTS ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.events (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sponsor_id      UUID REFERENCES public.profiles(id),
  title           TEXT NOT NULL,
  sport           TEXT NOT NULL,
  description     TEXT,
  location        GEOGRAPHY(POINT,4326) NOT NULL,
  lat             DOUBLE PRECISION NOT NULL,
  lng             DOUBLE PRECISION NOT NULL,
  venue_name      TEXT NOT NULL,
  venue_address   TEXT,
  scheduled_at    TIMESTAMPTZ NOT NULL,
  duration_min    INT DEFAULT 90,
  max_capacity    INT NOT NULL DEFAULT 20,
  spots_rx        INT DEFAULT 0,
  spots_scaled    INT DEFAULT 0,
  spots_beginner  INT DEFAULT 0,
  price_mxn       NUMERIC(8,2) DEFAULT 0,
  wod_description JSONB DEFAULT '[]',
  is_sponsored    BOOLEAN DEFAULT TRUE,
  status          TEXT DEFAULT 'open'
                  CHECK (status IN ('open','full','completed','cancelled')),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS events_location_gist ON public.events USING GIST(location);
CREATE INDEX IF NOT EXISTS events_scheduled_idx ON public.events(scheduled_at);

-- ── EVENT REGISTRATIONS ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.event_registrations (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id     UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
  user_id      UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  level        TEXT NOT NULL CHECK (level IN ('rx','scaled','beginner')),
  status       TEXT DEFAULT 'registered'
               CHECK (status IN ('registered','attended','cancelled','no_show')),
  registered_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(event_id, user_id)
);

-- ── RATINGS ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.ratings (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id     UUID REFERENCES public.sessions(id),
  event_id       UUID REFERENCES public.events(id),
  rater_id       UUID NOT NULL REFERENCES public.profiles(id),
  rated_id       UUID NOT NULL REFERENCES public.profiles(id),
  punctuality    INT NOT NULL CHECK (punctuality BETWEEN 1 AND 5),
  level_accuracy INT NOT NULL CHECK (level_accuracy BETWEEN 1 AND 5),
  respect        INT NOT NULL CHECK (respect BETWEEN 1 AND 5),
  overall        NUMERIC(3,2) GENERATED ALWAYS AS
                 (ROUND(((punctuality + level_accuracy + respect) / 3.0)::numeric, 2)) STORED,
  comment        TEXT,
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT rating_has_context CHECK (session_id IS NOT NULL OR event_id IS NOT NULL),
  UNIQUE(session_id, rater_id, rated_id),
  UNIQUE(event_id, rater_id, rated_id)
);

-- Trigger: recalcular rating promedio del usuario calificado
CREATE OR REPLACE FUNCTION public.recalculate_profile_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.profiles
  SET
    rating = (
      SELECT ROUND(AVG(overall)::numeric, 2)
      FROM public.ratings
      WHERE rated_id = NEW.rated_id
    ),
    total_sessions = (
      SELECT COUNT(DISTINCT session_id) + COUNT(DISTINCT event_id)
      FROM public.ratings
      WHERE rated_id = NEW.rated_id
    )
  WHERE id = NEW.rated_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER rating_recalculate
  AFTER INSERT ON public.ratings
  FOR EACH ROW EXECUTE FUNCTION public.recalculate_profile_rating();

-- ── CHATS & MESSAGES ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.chats (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id  UUID REFERENCES public.sessions(id),
  event_id    UUID REFERENCES public.events(id),
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT chat_has_context CHECK (session_id IS NOT NULL OR event_id IS NOT NULL)
);

CREATE TABLE IF NOT EXISTS public.messages (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  chat_id     UUID NOT NULL REFERENCES public.chats(id) ON DELETE CASCADE,
  sender_id   UUID NOT NULL REFERENCES public.profiles(id),
  content     TEXT NOT NULL CHECK (char_length(content) > 0),
  sent_at     TIMESTAMPTZ DEFAULT NOW()
);

-- Habilitar Realtime en messages para chat en vivo
ALTER TABLE public.messages REPLICA IDENTITY FULL;

-- ── FUNCIÓN GEOESPACIAL ───────────────────────────────────────
-- Retorna sesiones abiertas cerca de las coordenadas dadas
CREATE OR REPLACE FUNCTION public.get_nearby_sessions(
  user_lat    FLOAT,
  user_lng    FLOAT,
  radius_km   FLOAT DEFAULT 3.0,
  sport_filter TEXT DEFAULT NULL
)
RETURNS TABLE (
  id              UUID,
  host_id         UUID,
  sport           TEXT,
  level           TEXT,
  scheduled_at    TIMESTAMPTZ,
  duration_min    INT,
  max_spots       INT,
  spots_available INT,
  zone_name       TEXT,
  lat             DOUBLE PRECISION,
  lng             DOUBLE PRECISION,
  notes           TEXT,
  women_only      BOOLEAN,
  status          TEXT,
  created_at      TIMESTAMPTZ,
  distance_m      FLOAT,
  host_name       TEXT,
  host_rating     NUMERIC,
  host_avatar     TEXT,
  host_attendance NUMERIC
) AS $$
  SELECT
    s.id, s.host_id, s.sport, s.level, s.scheduled_at,
    s.duration_min, s.max_spots, s.spots_available,
    s.zone_name, s.lat, s.lng, s.notes, s.women_only,
    s.status, s.created_at,
    ST_Distance(s.location, ST_MakePoint(user_lng, user_lat)::geography) AS distance_m,
    p.display_name AS host_name,
    p.rating       AS host_rating,
    p.avatar_url   AS host_avatar,
    p.attendance_rate AS host_attendance
  FROM public.sessions s
  JOIN public.profiles p ON s.host_id = p.id
  WHERE
    s.status = 'open'
    AND s.scheduled_at > NOW()
    AND ST_DWithin(
      s.location,
      ST_MakePoint(user_lng, user_lat)::geography,
      radius_km * 1000
    )
    AND (sport_filter IS NULL OR s.sport = sport_filter)
  ORDER BY distance_m ASC
  LIMIT 50;
$$ LANGUAGE SQL STABLE;

-- Función similar para eventos
CREATE OR REPLACE FUNCTION public.get_nearby_events(
  user_lat    FLOAT,
  user_lng    FLOAT,
  radius_km   FLOAT DEFAULT 5.0
)
RETURNS TABLE (
  id              UUID,
  title           TEXT,
  sport           TEXT,
  lat             DOUBLE PRECISION,
  lng             DOUBLE PRECISION,
  venue_name      TEXT,
  scheduled_at    TIMESTAMPTZ,
  spots_rx        INT,
  spots_scaled    INT,
  spots_beginner  INT,
  price_mxn       NUMERIC,
  is_sponsored    BOOLEAN,
  status          TEXT,
  distance_m      FLOAT
) AS $$
  SELECT
    e.id, e.title, e.sport, e.lat, e.lng,
    e.venue_name, e.scheduled_at,
    e.spots_rx, e.spots_scaled, e.spots_beginner,
    e.price_mxn, e.is_sponsored, e.status,
    ST_Distance(e.location, ST_MakePoint(user_lng, user_lat)::geography) AS distance_m
  FROM public.events e
  WHERE
    e.status = 'open'
    AND e.scheduled_at > NOW()
    AND ST_DWithin(
      e.location,
      ST_MakePoint(user_lng, user_lat)::geography,
      radius_km * 1000
    )
  ORDER BY e.scheduled_at ASC
  LIMIT 20;
$$ LANGUAGE SQL STABLE;

-- ── ROW LEVEL SECURITY ────────────────────────────────────────
ALTER TABLE public.profiles          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ratings           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chats             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages          ENABLE ROW LEVEL SECURITY;

-- Profiles: lectura pública, edición solo del propio perfil
CREATE POLICY "profiles_select_all" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "profiles_insert_own" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Sessions: lectura pública de sesiones abiertas, gestión solo del host
CREATE POLICY "sessions_select_open" ON public.sessions FOR SELECT USING (status != 'cancelled');
CREATE POLICY "sessions_insert_auth" ON public.sessions FOR INSERT WITH CHECK (auth.uid() = host_id);
CREATE POLICY "sessions_update_host" ON public.sessions FOR UPDATE USING (auth.uid() = host_id);
CREATE POLICY "sessions_delete_host" ON public.sessions FOR DELETE USING (auth.uid() = host_id);

-- Session participants
CREATE POLICY "participants_select" ON public.session_participants
  FOR SELECT USING (
    auth.uid() = user_id OR
    auth.uid() = (SELECT host_id FROM public.sessions WHERE id = session_id)
  );
CREATE POLICY "participants_insert_auth" ON public.session_participants
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "participants_update_own" ON public.session_participants
  FOR UPDATE USING (auth.uid() = user_id);

-- Events: lectura pública
CREATE POLICY "events_select_all" ON public.events FOR SELECT USING (true);
CREATE POLICY "events_insert_sponsor" ON public.events FOR INSERT WITH CHECK (auth.uid() = sponsor_id);

-- Event registrations
CREATE POLICY "event_reg_select" ON public.event_registrations
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "event_reg_insert" ON public.event_registrations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Ratings: insertar solo si participaste
CREATE POLICY "ratings_select" ON public.ratings FOR SELECT USING (true);
CREATE POLICY "ratings_insert_auth" ON public.ratings FOR INSERT WITH CHECK (auth.uid() = rater_id);

-- Messages: solo participantes del chat
CREATE POLICY "messages_select" ON public.messages
  FOR SELECT USING (auth.uid() = sender_id OR TRUE); -- Simplificado para MVP
CREATE POLICY "messages_insert_auth" ON public.messages
  FOR INSERT WITH CHECK (auth.uid() = sender_id);

-- Habilitar Realtime en las tablas necesarias
ALTER PUBLICATION supabase_realtime ADD TABLE public.sessions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.session_participants;
```

---

## PASO 7 — Repositories

### `lib/data/repositories/session_repository.dart`

Implementa los siguientes métodos con el Supabase Flutter SDK:

```dart
class SessionRepository {
  final SupabaseClient _client;
  SessionRepository(this._client);

  // Sesiones cercanas via RPC PostGIS (llama a get_nearby_sessions)
  Future<List<SessionModel>> getNearbySessions({
    required double lat,
    required double lng,
    double radiusKm = 3.0,
    String? sport,
  }) async { ... }

  // Publicar nueva sesión
  // El campo location usa WKT: ST_MakePoint(lng, lat)
  // Pasar lat y lng como columnas independientes también
  Future<SessionModel> createSession({
    required String sport,
    required String level,
    required DateTime scheduledAt,
    required int durationMin,
    required int maxSpots,
    required String zoneName,
    required double lat,
    required double lng,
    String? notes,
    required bool womenOnly,
  }) async { ... }

  // Unirse a sesión (INSERT en session_participants con status 'pending')
  Future<void> joinSession(String sessionId) async { ... }

  // Aceptar participante (solo el host puede)
  Future<void> acceptParticipant(String sessionId, String userId) async { ... }

  // Cancelar participación propia
  Future<void> cancelParticipation(String sessionId) async { ... }

  // Stream Realtime de sesiones en zona (para actualizar el mapa en vivo)
  Stream<List<Map<String, dynamic>>> watchSessionsInZone({
    required double lat,
    required double lng,
  }) { ... }

  // Obtener participantes de una sesión
  Future<List<ProfileModel>> getSessionParticipants(String sessionId) async { ... }

  // Sesiones del usuario (como host o participante)
  Future<List<SessionModel>> getUserSessions(String userId) async { ... }

  // Marcar sesión como completada (solo host)
  Future<void> completeSession(String sessionId) async { ... }
}
```

### `lib/data/repositories/event_repository.dart`

Métodos: `getNearbyEvents(lat, lng, radiusKm)`, `getEventById(id)`, `registerForEvent(eventId, level)`, `cancelEventRegistration(eventId)`, `getUserEventRegistrations()`.

### `lib/data/repositories/profile_repository.dart`

Métodos: `getProfile(userId)`, `getCurrentProfile()`, `updateProfile(ProfileModel)`, `uploadAvatar(File)`, `getProfilesByIds(List<String>)`.

### `lib/data/repositories/rating_repository.dart`

Métodos: `rateUser({sessionId?, eventId?, ratedId, punctuality, levelAccuracy, respect, comment?})`, `getSessionRatings(sessionId)`, `getUserRatings(userId)`, `hasPendingRating(sessionId)`.

---

## PASO 8 — Providers (Riverpod)

### `lib/data/providers/supabase_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Repos
final sessionRepoProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(ref.watch(supabaseClientProvider));
});
final eventRepoProvider = Provider<EventRepository>((ref) {
  return EventRepository(ref.watch(supabaseClientProvider));
});
final profileRepoProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
});
final ratingRepoProvider = Provider<RatingRepository>((ref) {
  return RatingRepository(ref.watch(supabaseClientProvider));
});
```

### `lib/features/map/providers/map_provider.dart`

```dart
// StateNotifier que maneja:
// - posición actual del usuario (Position?)
// - sesiones cercanas (List<SessionModel>)
// - eventos cercanos (List<EventModel>)
// - filtro de deporte activo (String?)
// - radio de búsqueda (double)
// - estado de carga (isLoading, error)

class MapState {
  final Position? userPosition;
  final List<SessionModel> sessions;
  final List<EventModel> events;
  final String? activeSportFilter;
  final double searchRadiusKm;
  final bool isLoading;
  final String? error;
  // ...
}

class MapNotifier extends StateNotifier<MapState> {
  // loadUserLocation() — pide permiso y obtiene GPS
  // loadNearbySessions() — llama a sessionRepo.getNearbySessions()
  // setFilter(sport?) — filtra sin re-fetch
  // subscribeToRealtime() — escucha cambios en sesiones
  // dispose() cancela subscripciones
}

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier(
    ref.watch(sessionRepoProvider),
    ref.watch(eventRepoProvider),
  );
});
```

---

## PASO 9 — Páginas principales (Sprint 1)

### `lib/features/auth/pages/phone_input_page.dart`

- Campo de teléfono con validación formato México (+52)
- Botón "Enviar código" → `supabase.auth.signInWithOtp(phone: phone)`
- Navega a `OtpVerifyPage`

### `lib/features/auth/pages/otp_verify_page.dart`

- 6 inputs OTP (usa `pin_code_fields` o implementa manual)
- "Verificar" → `supabase.auth.verifyOTP(phone, token, type: OtpType.sms)`
- Si no tiene perfil completo → navega a `EditProfilePage`
- Si ya tiene perfil → navega a `/` (MapPage)

### `lib/features/map/pages/map_page.dart`

Implementa la pantalla principal con:

1. **FlutterMap** ocupando 50% superior de pantalla con:
   - TileLayer OpenStreetMap
   - MarkerLayer con `SessionPin` para sesiones
   - MarkerLayer con `EventPin` para eventos (estilo diferente — amber/naranja)
   - Marcador del usuario (punto azul con animación pulse)
   - Centrar en posición del usuario al cargar

2. **FilterChips** horizontales debajo del mapa:
   - "Todo", "CrossFit", "Calistenia", "HIIT", "Eventos"
   - Al seleccionar → filtra `MapState.sessions` por deporte
   - Chip activo: fondo ink + texto volt

3. **ListView** de `SessionCard` debajo de los chips mostrando sesiones filtradas

4. **FAB** con "+" en esquina inferior derecha → navega a `/publish`

5. **BottomNavigationBar** con 4 tabs: Mapa, Eventos, Chats, Perfil

### `lib/features/sessions/pages/publish_page.dart`

Formulario con:

1. `SportSelector` — grid 3x2 de deportes, selección single
2. `LevelSelector` — 3 opciones RX/Scaled/Beginner con colores
3. DateTimePicker para día y hora
4. Campo de zona/colonia (usa geocoding de la posición actual como default)
5. Slider para capacidad máxima (1–8 personas)
6. Campo de notas (opcional)
7. Toggle "Solo mujeres" (Switch)
8. Toggle "Notificaciones WhatsApp" (Switch, default ON)
9. Botón "Publicar en el mapa" → llama `sessionRepo.createSession()` → navega back

**Validaciones:** sport requerido, nivel requerido, hora futura, zona no vacía.

### `lib/features/profile/pages/profile_page.dart`

Muestra: avatar, nombre, badges de verificación, rating con estrellas, estadísticas (sesiones, asistencia%, eventos), deportes favoritos, horarios activos, toggle modo solo mujeres.

### `lib/features/profile/pages/edit_profile_page.dart`

Campos editables: foto de perfil (ImagePicker), nombre, bio, colonia, deportes (multi-select), nivel, horarios preferidos (chips por día), toggles. Botón "Guardar" → `profileRepo.updateProfile()`.

---

## PASO 10 — `main.dart` y `app.dart`

### `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/env/env.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.validate();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 40,
    ),
  );

  runApp(const ProviderScope(child: SportMatchApp()));
}
```

### `lib/app.dart`

```dart
// GoRouter con las siguientes rutas:
// / → MapPage (requiere auth)
// /auth/phone → PhoneInputPage
// /auth/otp → OtpVerifyPage
// /publish → PublishPage (requiere auth)
// /session/:id → SessionDetailPage
// /event/:id → EventDetailPage
// /profile → ProfilePage (requiere auth)
// /profile/edit → EditProfilePage
// /chat/:chatId → ChatPage
// /rate/:sessionId → RatingPage

// Redirect: si no hay sesión de Supabase → /auth/phone
// MaterialApp.router con AppColors.lightTheme
```

---

## PASO 11 — Permisos nativos

### Android `android/app/src/main/AndroidManifest.xml`

Agrega dentro de `<manifest>`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

### iOS `ios/Runner/Info.plist`

Agrega dentro de `<dict>`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>SportMatch necesita tu ubicación para mostrarte sesiones deportivas cerca de ti en el mapa.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>SportMatch puede notificarte cuando hay sesiones en tu zona.</string>
```

---

## PASO 12 — `README.md`

Crea un README completo con:

- Descripción del proyecto
- Setup en 5 pasos (clone → copiar .env → flutter pub get → ejecutar SQL → flutter run)
- Variables de entorno necesarias
- Cómo ejecutar: `flutter run --dart-define-from-file=.env`
- Arquitectura resumida
- Stack técnico

---

## VERIFICACIÓN SPRINT 1

Al terminar el Sprint 1, ejecuta y verifica que:

```bash
flutter analyze                    # 0 errores, 0 warnings críticos
flutter run --dart-define-from-file=.env  # Corre en simulador
```

Checklist funcional mínimo:

- [ ] App abre sin crash en iOS y Android
- [ ] Auth OTP con Supabase funciona (prueba con número real)
- [ ] Mapa carga con tiles de OpenStreetMap
- [ ] GPS del usuario aparece como punto en el mapa
- [ ] CRUD de sesión funciona: publicar → aparece en mapa
- [ ] Filtros de deporte funcionan en cliente
- [ ] Perfil se guarda y lee de Supabase
- [ ] Navegar entre las 4 tabs sin crash

---

---

# SPRINT 2 — Notificaciones WhatsApp, Eventos, Chat y Ratings

**Objetivo:** Flujo completo de coordinación: notificaciones WA funcionando, eventos patrocinados en el mapa, chat pre-sesión, ratings post-sesión, modo solo mujeres.

---

## PASO 13 — Supabase Edge Functions

Instala Supabase CLI si no está:

```bash
npm install -g supabase
supabase login
supabase link --project-ref TU_PROJECT_REF
```

### `supabase/functions/notify-whatsapp/index.ts`

```typescript
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const WHATSAPP_TOKEN = Deno.env.get("WHATSAPP_TOKEN")!;
const PHONE_NUMBER_ID = Deno.env.get("WHATSAPP_PHONE_NUMBER_ID")!;
const WA_VERSION = Deno.env.get("WHATSAPP_API_VERSION") ?? "v19.0";

interface NotifyPayload {
  to_phone: string; // "521XXXXXXXXXX"
  template_name: string; // "alguien_se_unio" | "sesion_nueva_match" | etc.
  params: string[]; // parámetros del template en orden
  language?: string; // default: "es_MX"
}

serve(async (req: Request) => {
  // Verificar que viene de Supabase (JWT válido)
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return new Response("Unauthorized", { status: 401 });
  }

  try {
    const payload: NotifyPayload = await req.json();

    if (!payload.to_phone || !payload.template_name) {
      return new Response(
        JSON.stringify({ error: "to_phone y template_name son requeridos" }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    const response = await fetch(
      `https://graph.facebook.com/${WA_VERSION}/${PHONE_NUMBER_ID}/messages`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${WHATSAPP_TOKEN}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          messaging_product: "whatsapp",
          to: payload.to_phone,
          type: "template",
          template: {
            name: payload.template_name,
            language: { code: payload.language ?? "es_MX" },
            components:
              payload.params.length > 0
                ? [
                    {
                      type: "body",
                      parameters: payload.params.map((p) => ({
                        type: "text",
                        text: p,
                      })),
                    },
                  ]
                : [],
          },
        }),
      },
    );

    const data = await response.json();

    if (!response.ok) {
      console.error("WhatsApp API error:", JSON.stringify(data));
      return new Response(
        JSON.stringify({ error: "WhatsApp API error", details: data }),
        { status: 500, headers: { "Content-Type": "application/json" } },
      );
    }

    return new Response(
      JSON.stringify({ success: true, message_id: data.messages?.[0]?.id }),
      { headers: { "Content-Type": "application/json" } },
    );
  } catch (err) {
    console.error("Edge Function error:", err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
```

### `supabase/functions/match-users/index.ts`

Edge Function que cuando se llama con un `session_id`:

1. Lee la sesión de la DB (sport, level, location, scheduled_at, women_only)
2. Busca perfiles con: `sport` en `profiles.sports`, nivel compatible, `whatsapp_optin = true`, ubicación a < 5km de la sesión
3. Para cada perfil encontrado (máx 20), llama internamente a `notify-whatsapp` con template `sesion_nueva_match`
4. Retorna cuántas notificaciones envió

### `supabase/functions/request-ratings/index.ts`

Cron job que se ejecuta cada hora (configura en Supabase Dashboard → Edge Functions → Schedule):

1. Busca sesiones donde `status = 'completed'` y `scheduled_at + 2h <= NOW()`
2. Para cada sesión, busca participantes que aún no han dejado rating
3. Llama a `notify-whatsapp` con template `solicitar_rating` para cada uno
4. Marca en una tabla auxiliar que ya se pidió el rating (evitar duplicados)

**Deploy de functions:**

```bash
supabase functions deploy notify-whatsapp
supabase functions deploy match-users
supabase functions deploy request-ratings

# Configurar secrets en Supabase (NO en código):
supabase secrets set WHATSAPP_TOKEN=EAAxxxxx
supabase secrets set WHATSAPP_PHONE_NUMBER_ID=123456789
supabase secrets set WHATSAPP_API_VERSION=v19.0
```

---

## PASO 14 — Templates WhatsApp

Documenta en `supabase/functions/README_TEMPLATES.md` los 5 templates que hay que crear y aprobar en Meta Business Manager antes de poder usarlos:

```markdown
# Templates WhatsApp — SportMatch

Crear en: business.facebook.com → WhatsApp → Message Templates

## 1. sesion_nueva_match (Utility)

Nombre: sesion_nueva_match
Idioma: Español (México)
Categoría: Utility
Texto del body:
"Hay una sesión de {{1}} cerca de ti mañana a las {{2}} en {{3}}.
Nivel: {{4}}. {{5}} lugar(es) disponible(s).
Abre SportMatch para unirte → [LINK]"
Parámetros: [sport, hora, zona, nivel, spots]

## 2. alguien_se_unio (Utility)

Body: "{{1}} quiere unirse a tu sesión de {{2}} mañana a las {{3}}.
Acepta o rechaza en SportMatch."
Parámetros: [nombre_participante, sport, hora]

## 3. participacion_aceptada (Utility)

Body: "¡{{1}} aceptó tu solicitud! Tu sesión de {{2}} es mañana a las {{3}} en {{4}}.
Abre el chat para confirmar el punto exacto de encuentro."
Parámetros: [nombre_host, sport, hora, zona]

## 4. recordatorio_sesion (Utility)

Body: "⏰ Recordatorio: tienes una sesión de {{1}} en 1 hora ({{2}}) con {{3}} en {{4}}.
¡No los dejes esperando!"
Parámetros: [sport, hora, compañero, zona]

## 5. solicitar_rating (Utility)

Body: "¿Cómo estuvo tu sesión de {{1}} con {{2}}? Tu calificación ayuda a la comunidad.
Abre SportMatch para calificar (30 segundos)."
Parámetros: [sport, nombre_compañero]

NOTA: Los templates deben aprobarse por Meta antes de usarse (24-48h).
Mientras se aprueban, la app funciona sin notificaciones WA.
```

---

## PASO 15 — Integración WhatsApp desde Flutter

En `lib/data/repositories/session_repository.dart`, después de operaciones clave, llama a la Edge Function:

```dart
// En joinSession():
Future<void> joinSession(String sessionId) async {
  // 1. Insertar participante
  await _client.from('session_participants').insert({
    'session_id': sessionId,
    'user_id': _client.auth.currentUser!.id,
    'status': 'pending',
  });

  // 2. Notificar al host por WhatsApp (fire and forget)
  final session = await getSessionById(sessionId);
  final myProfile = await _getMyProfile();
  if (session.host?.whatsappOptin == true) {
    _client.functions.invoke('notify-whatsapp', body: {
      'to_phone': session.host!.phone,
      'template_name': 'alguien_se_unio',
      'params': [
        myProfile.displayName,
        session.sport,
        _formatTime(session.scheduledAt),
      ],
    }).catchError((e) => print('WA notify failed: $e')); // No bloquear el flujo
  }
}
```

Aplica el mismo patrón en: `createSession()` (llama `match-users`), `acceptParticipant()` (notifica con `participacion_aceptada`), `completeSession()` (el cron job de ratings se encarga).

---

## PASO 16 — Páginas Sprint 2

### `lib/features/sessions/pages/session_detail_page.dart`

- Header con deporte, nivel, hora, zona
- Info del host (avatar, nombre, rating, badge INE si aplica)
- Lista de participantes con estado
- Botón "Unirse" → `sessionRepo.joinSession()`
- Botón "Abrir Chat" → navega a `/chat/:chatId`
- Si es el host: botones "Aceptar/Rechazar" por participante
- Si sesión completada y sin rating → banner "Califica tu sesión"

### `lib/features/events/pages/event_detail_page.dart`

- Header oscuro (ink) con badge "Evento Patrocinado"
- Stats: cupos totales, spots libres, costo
- GymCard: logo, nombre, dirección, badge verificado
- WOD description (lista de ejercicios desde JSONB)
- LevelAvailability: cupos disponibles por nivel
- `LevelSelector` para elegir nivel antes de inscribirse
- Botón "Inscribirme" (amber) → `eventRepo.registerForEvent()`
- Botón "Chat del evento" → navega al chat grupal del evento

### `lib/features/chat/pages/chat_page.dart`

- AppBar con nombre de la sesión/evento + "🔒 Ubicación no revelada"
- Lista de mensajes en tiempo real via `supabase.from('messages').stream()`
- Banner de aviso: "La ubicación exacta se comparte cuando ambos confirmen"
- Input de texto + botón enviar
- Botón "Confirmar punto de encuentro" (solo disponible cuando hay ≥1 mensaje de cada parte)

Implementar Stream Realtime:

```dart
final messagesStream = supabase
    .from('messages')
    .stream(primaryKey: ['id'])
    .eq('chat_id', chatId)
    .order('sent_at')
    .map((rows) => rows.map(MessageModel.fromMap).toList());
```

### `lib/features/ratings/pages/rating_page.dart`

- Header con nombre del compañero + foto + sesión
- 3 criterios con StarRating widget (1-5):
  - Puntualidad ("¿Llegó a tiempo?")
  - Nivel declarado ("¿Correspondía al nivel del perfil?")
  - Respeto ("¿Fue una experiencia segura y respetuosa?")
- Campo de comentario opcional (TextArea)
- Botón "Enviar calificación" → `ratingRepo.rateUser()`
- Al enviar → navega de vuelta y muestra snackbar "¡Gracias! Tu calificación ayuda a la comunidad"

---

## PASO 17 — Widgets compartidos

### `lib/shared/widgets/sport_match_button.dart`

```dart
enum SmButtonVariant { ink, volt, mist, amber, red }

class SportMatchButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final SmButtonVariant variant;
  final bool fullWidth;
  final bool isLoading;
  final String? icon;
  // ...
  // Barlow Condensed, uppercase, letra-spacing 0.08
  // Border radius 12
  // Padding vertical 14, horizontal 24
}
```

### `lib/shared/widgets/sport_match_badge.dart`

```dart
enum SmBadgeVariant { ine, phone, event, women, req, opt, level }
// Badge compacto con ícono + texto
// Colores según variante (ink+volt, teal, amber, purple, etc.)
```

### `lib/shared/widgets/sport_match_card.dart`

// Card base: border 1px solid AppColors.border, radius 20, fondo white
// Variantes: default, event (amber border), women (purple border)

### `lib/features/map/widgets/session_pin.dart`

```dart
// Bubble estilo "Roma Norte · 7:00am"
// Colores: ink (sesión normal), amber (evento), teal (mujeres)
// Mostrar emoji del deporte + hora
// onTap → abrir bottom sheet con resumen de la sesión
```

### `lib/features/sessions/widgets/session_card.dart`

```dart
// Card horizontal con:
// - Emoji del deporte (cuadro de color)
// - Nombre del host + rating
// - Zona + distancia
// - Hora
// - Badges: INE ✓, Solo mujeres, nivel, spots
// - Botón "Unirse" o "Ver →" si es evento
// - Borde amber si isEvent, borde purple si womenOnly
```

---

## PASO 18 — `LocationService` completo

```dart
// lib/core/utils/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Position> getCurrentPosition() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw LocationException('Activa los servicios de ubicación en tu dispositivo.');

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw LocationException('SportMatch necesita tu ubicación para encontrar sesiones cercanas.');
      }
    }
    if (perm == LocationPermission.deniedForever) {
      throw LocationException('Permiso de ubicación bloqueado. Ve a Configuración → SportMatch → Ubicación.');
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static Future<String> getNeighborhood(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng,
          localeIdentifier: 'es_MX');
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [p.subLocality, p.locality]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        return parts.join(', ');
      }
    } catch (_) {}
    return 'CDMX';
  }

  static Stream<Position> getStream({int distanceFilterMeters = 50}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilterMeters,
      ),
    );
  }

  // Convierte Position a WKT para PostGIS
  static String toWkt(double lat, double lng) => 'POINT($lng $lat)';
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);
  @override String toString() => message;
}
```

---

## PASO 19 — Migración SQL Sprint 2

Agrega en `supabase/migrations/002_ratings_request_tracking.sql`:

```sql
-- Tabla para evitar pedir ratings duplicados
CREATE TABLE IF NOT EXISTS public.rating_requests (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id  UUID REFERENCES public.sessions(id),
  event_id    UUID REFERENCES public.events(id),
  user_id     UUID NOT NULL REFERENCES public.profiles(id),
  sent_at     TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(session_id, user_id),
  UNIQUE(event_id, user_id)
);

ALTER TABLE public.rating_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "rr_own" ON public.rating_requests FOR SELECT USING (auth.uid() = user_id);

-- Índice para el cron job de ratings
CREATE INDEX IF NOT EXISTS sessions_completed_idx
  ON public.sessions(scheduled_at)
  WHERE status = 'completed';
```

---

## VERIFICACIÓN SPRINT 2

Checklist funcional completo:

- [ ] Publicar sesión → aparece en mapa en tiempo real (Realtime)
- [ ] Unirse a sesión → host recibe notificación WhatsApp (o log de Edge Function si templates pendientes)
- [ ] Chat entre host y participante funciona con mensajes en tiempo real
- [ ] Evento patrocinado aparece con pin especial en el mapa
- [ ] Registrarse en evento → registro guardado en Supabase
- [ ] Rating post-sesión: 3 criterios, se guarda en DB, recalcula rating del usuario
- [ ] Toggle "Solo mujeres" filtra correctamente en el mapa
- [ ] Modo oscuro del mapa (OpenStreetMap carga correctamente)
- [ ] `flutter analyze` → 0 errores
- [ ] `flutter test` → todos los unit tests pasan

---

## ENTREGA FINAL

Al terminar ambos sprints, dame:

1. **Árbol completo del proyecto** (`tree -L 4 --gitignore`)
2. **Lista de todos los archivos creados** con su propósito en una línea
3. **Instrucciones de setup completas** para que otro dev pueda correr el proyecto desde cero en 10 minutos
4. **Decisiones de arquitectura** que tomaste y por qué (máx 10 puntos)
5. **Qué queda pendiente** para el Sprint 3 (Google Maps migration, in-app purchases, analytics)
6. **Comando exacto para correr la app:**
   ```bash
   flutter run --dart-define-from-file=.env -d <device_id>
   ```

---

## REGLAS GENERALES PARA CLAUDE CODE

- **Nunca** hardcodees credenciales. Todo va en `.env` y se lee via `Env.*`
- **Siempre** maneja errores en operaciones de red con try/catch y mensajes útiles al usuario
- **Siempre** muestra loading states mientras se cargan datos de Supabase
- **No** uses `setState` — todo el estado va en Riverpod providers
- **No** pongas lógica de negocio en las páginas — va en repositories y providers
- **Sí** escribe comentarios en los métodos complejos (PostGIS queries, Realtime subscriptions)
- Sigue el color system de `AppColors` en todos los widgets — nunca `Colors.blue` directo
- Usa `AppTextStyles` para toda la tipografía — nunca `TextStyle` con font hardcodeado
- Los borders radius son: 12 (cards internas), 20 (cards principales), 28 (modales/hero)
- Tono de la app: deportivo, directo, pocas palabras — como los mockups en `sportmatch_mockup.html`
  MARKDOWN
  echo "Prompt creado exitosamente"
