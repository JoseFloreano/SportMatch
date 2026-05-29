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

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
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

DROP TRIGGER IF EXISTS session_participants_spots ON public.session_participants;
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

DROP TRIGGER IF EXISTS rating_recalculate ON public.ratings;
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
ALTER TABLE public.profiles            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.session_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ratings             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chats               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages            ENABLE ROW LEVEL SECURITY;

-- Profiles: lectura pública, edición solo del propio perfil
DROP POLICY IF EXISTS "profiles_select_all" ON public.profiles;
CREATE POLICY "profiles_select_all" ON public.profiles FOR SELECT USING (true);
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
CREATE POLICY "profiles_insert_own" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Sessions: lectura pública de sesiones abiertas, gestión solo del host
DROP POLICY IF EXISTS "sessions_select_open" ON public.sessions;
CREATE POLICY "sessions_select_open" ON public.sessions FOR SELECT USING (status != 'cancelled');
DROP POLICY IF EXISTS "sessions_insert_auth" ON public.sessions;
CREATE POLICY "sessions_insert_auth" ON public.sessions FOR INSERT WITH CHECK (auth.uid() = host_id);
DROP POLICY IF EXISTS "sessions_update_host" ON public.sessions;
CREATE POLICY "sessions_update_host" ON public.sessions FOR UPDATE USING (auth.uid() = host_id);
DROP POLICY IF EXISTS "sessions_delete_host" ON public.sessions;
CREATE POLICY "sessions_delete_host" ON public.sessions FOR DELETE USING (auth.uid() = host_id);

-- Session participants
DROP POLICY IF EXISTS "participants_select" ON public.session_participants;
CREATE POLICY "participants_select" ON public.session_participants
  FOR SELECT USING (
    auth.uid() = user_id OR
    auth.uid() = (SELECT host_id FROM public.sessions WHERE id = session_id)
  );
DROP POLICY IF EXISTS "participants_insert_auth" ON public.session_participants;
CREATE POLICY "participants_insert_auth" ON public.session_participants
  FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "participants_update_own" ON public.session_participants;
CREATE POLICY "participants_update_own" ON public.session_participants
  FOR UPDATE USING (auth.uid() = user_id);

-- Events: lectura pública
DROP POLICY IF EXISTS "events_select_all" ON public.events;
CREATE POLICY "events_select_all" ON public.events FOR SELECT USING (true);
DROP POLICY IF EXISTS "events_insert_sponsor" ON public.events;
CREATE POLICY "events_insert_sponsor" ON public.events FOR INSERT WITH CHECK (auth.uid() = sponsor_id);

-- Event registrations
DROP POLICY IF EXISTS "event_reg_select" ON public.event_registrations;
CREATE POLICY "event_reg_select" ON public.event_registrations
  FOR SELECT USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "event_reg_insert" ON public.event_registrations;
CREATE POLICY "event_reg_insert" ON public.event_registrations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Ratings: insertar solo si eres el rater
DROP POLICY IF EXISTS "ratings_select" ON public.ratings;
CREATE POLICY "ratings_select" ON public.ratings FOR SELECT USING (true);
DROP POLICY IF EXISTS "ratings_insert_auth" ON public.ratings;
CREATE POLICY "ratings_insert_auth" ON public.ratings FOR INSERT WITH CHECK (auth.uid() = rater_id);

-- Messages: insertar solo como el propio sender (lectura simplificada para MVP)
DROP POLICY IF EXISTS "messages_select" ON public.messages;
CREATE POLICY "messages_select" ON public.messages
  FOR SELECT USING (true); -- Simplificado para MVP
DROP POLICY IF EXISTS "messages_insert_auth" ON public.messages;
CREATE POLICY "messages_insert_auth" ON public.messages
  FOR INSERT WITH CHECK (auth.uid() = sender_id);

-- Chats: lectura pública para MVP
DROP POLICY IF EXISTS "chats_select" ON public.chats;
CREATE POLICY "chats_select" ON public.chats FOR SELECT USING (true);
DROP POLICY IF EXISTS "chats_insert_auth" ON public.chats;
CREATE POLICY "chats_insert_auth" ON public.chats FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- Habilitar Realtime en las tablas necesarias
ALTER PUBLICATION supabase_realtime ADD TABLE public.sessions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.session_participants;
