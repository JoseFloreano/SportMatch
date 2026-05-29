-- ═══════════════════════════════════════════════════════════
-- SportMatch — Sprint 2 (matching + chat + ratings tracking)
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- ═══════════════════════════════════════════════════════════

-- ── PROFILE LOCATION ────────────────────────────────────────
-- Para que match-users pueda filtrar por distancia con ST_DWithin.
-- Se llena cuando el usuario abre el mapa (set_my_location RPC).
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS location GEOGRAPHY(POINT, 4326),
  ADD COLUMN IF NOT EXISTS lat DOUBLE PRECISION,
  ADD COLUMN IF NOT EXISTS lng DOUBLE PRECISION;

CREATE INDEX IF NOT EXISTS profiles_location_gist
  ON public.profiles USING GIST(location);

CREATE OR REPLACE FUNCTION public.set_my_location(
  p_lat DOUBLE PRECISION,
  p_lng DOUBLE PRECISION
)
RETURNS VOID AS $$
  UPDATE public.profiles
  SET
    location = ST_MakePoint(p_lng, p_lat)::geography,
    lat = p_lat,
    lng = p_lng,
    updated_at = NOW()
  WHERE id = auth.uid();
$$ LANGUAGE SQL SECURITY DEFINER;

-- ── RATING REQUESTS (idempotencia del cron) ─────────────────
CREATE TABLE IF NOT EXISTS public.rating_requests (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id  UUID REFERENCES public.sessions(id) ON DELETE CASCADE,
  event_id    UUID REFERENCES public.events(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  sent_at     TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(session_id, user_id),
  UNIQUE(event_id, user_id)
);

ALTER TABLE public.rating_requests ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rr_own" ON public.rating_requests;
CREATE POLICY "rr_own" ON public.rating_requests
  FOR SELECT USING (auth.uid() = user_id);

-- Índice para el cron de ratings: encuentra rápido sesiones recientes completadas.
CREATE INDEX IF NOT EXISTS sessions_completed_idx
  ON public.sessions(scheduled_at)
  WHERE status = 'completed';

-- ── MATCHING RPC ─────────────────────────────────────────────
-- Devuelve usuarios compatibles para una sesión: deporte en sports[],
-- nivel compatible (igual o 'any' en cualquier lado), whatsapp_optin,
-- no es el host, no se ha unido ya, y si tienen location → < radius_km.
CREATE OR REPLACE FUNCTION public.find_match_candidates(
  session_id_param UUID,
  radius_km        FLOAT DEFAULT 5.0,
  max_candidates   INT   DEFAULT 20
)
RETURNS TABLE (
  user_id      UUID,
  display_name TEXT,
  phone        TEXT,
  distance_m   FLOAT
) AS $$
  WITH s AS (
    SELECT id, host_id, sport, level, location, women_only
    FROM public.sessions
    WHERE id = session_id_param
  )
  SELECT
    p.id           AS user_id,
    p.display_name AS display_name,
    p.phone        AS phone,
    CASE
      WHEN p.location IS NULL THEN NULL
      ELSE ST_Distance(p.location, (SELECT location FROM s))::float
    END AS distance_m
  FROM public.profiles p, s
  WHERE
    p.id <> s.host_id
    AND p.whatsapp_optin = TRUE
    AND p.phone IS NOT NULL
    AND s.sport = ANY(p.sports)
    AND (s.level = 'any' OR p.level IS NULL OR p.level = 'any' OR p.level = s.level)
    -- Modo Solo Mujeres: solo se incluyen perfiles con women_only_mode activo.
    AND (s.women_only = FALSE OR p.women_only_mode = TRUE)
    AND NOT EXISTS (
      SELECT 1 FROM public.session_participants sp
      WHERE sp.session_id = s.id AND sp.user_id = p.id
    )
    -- Si el perfil tiene ubicación, filtra por distancia. Si no, lo deja pasar.
    AND (
      p.location IS NULL
      OR ST_DWithin(p.location, (SELECT location FROM s), radius_km * 1000)
    )
  ORDER BY distance_m NULLS LAST
  LIMIT max_candidates;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;

-- ── CHAT por sesión (idempotente) ────────────────────────────
-- Devuelve el chat_id de la sesión; si no existe, lo crea.
CREATE OR REPLACE FUNCTION public.get_or_create_chat_for_session(
  p_session_id UUID
)
RETURNS UUID AS $$
DECLARE
  existing_id UUID;
  new_id      UUID;
BEGIN
  SELECT id INTO existing_id
  FROM public.chats
  WHERE session_id = p_session_id
  LIMIT 1;

  IF existing_id IS NOT NULL THEN
    RETURN existing_id;
  END IF;

  INSERT INTO public.chats (session_id) VALUES (p_session_id) RETURNING id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ── Cron de ratings: candidatos a recordatorio ──────────────
-- Devuelve sesiones completadas hace >= 2h cuyo participante (aceptado)
-- aún no recibió la solicitud de rating ni dejó rating.
CREATE OR REPLACE FUNCTION public.pending_rating_targets(
  hours_after INT DEFAULT 2
)
RETURNS TABLE (
  session_id UUID,
  user_id    UUID,
  phone      TEXT,
  display_name TEXT,
  sport      TEXT,
  companion_name TEXT
) AS $$
  SELECT
    s.id              AS session_id,
    sp.user_id        AS user_id,
    p.phone           AS phone,
    p.display_name    AS display_name,
    s.sport           AS sport,
    host.display_name AS companion_name
  FROM public.sessions s
  JOIN public.session_participants sp
    ON sp.session_id = s.id AND sp.status = 'accepted'
  JOIN public.profiles p ON p.id = sp.user_id
  JOIN public.profiles host ON host.id = s.host_id
  WHERE
    s.status = 'completed'
    AND s.scheduled_at + (hours_after || ' hours')::INTERVAL <= NOW()
    AND p.whatsapp_optin = TRUE
    AND p.phone IS NOT NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.rating_requests rr
      WHERE rr.session_id = s.id AND rr.user_id = sp.user_id
    )
    AND NOT EXISTS (
      SELECT 1 FROM public.ratings r
      WHERE r.session_id = s.id AND r.rater_id = sp.user_id
    )
  LIMIT 50;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;
