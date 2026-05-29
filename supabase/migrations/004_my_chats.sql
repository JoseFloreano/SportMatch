-- ═══════════════════════════════════════════════════════════
-- SportMatch — Bandeja de chats del usuario
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- ═══════════════════════════════════════════════════════════

-- Devuelve los chats donde el usuario es host de la sesión o participante
-- aceptado, con el último mensaje para el preview de la bandeja.
CREATE OR REPLACE FUNCTION public.my_chats()
RETURNS TABLE (
  chat_id         UUID,
  session_id      UUID,
  sport           TEXT,
  zone_name       TEXT,
  scheduled_at    TIMESTAMPTZ,
  is_host         BOOLEAN,
  last_message    TEXT,
  last_message_at TIMESTAMPTZ
) AS $$
  SELECT
    c.id              AS chat_id,
    s.id              AS session_id,
    s.sport           AS sport,
    s.zone_name       AS zone_name,
    s.scheduled_at    AS scheduled_at,
    (s.host_id = auth.uid()) AS is_host,
    lm.content        AS last_message,
    lm.sent_at        AS last_message_at
  FROM public.chats c
  JOIN public.sessions s ON s.id = c.session_id
  LEFT JOIN LATERAL (
    SELECT content, sent_at
    FROM public.messages m
    WHERE m.chat_id = c.id
    ORDER BY m.sent_at DESC
    LIMIT 1
  ) lm ON TRUE
  WHERE
    s.host_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.session_participants sp
      WHERE sp.session_id = s.id
        AND sp.user_id = auth.uid()
        AND sp.status = 'accepted'
    )
  ORDER BY COALESCE(lm.sent_at, s.scheduled_at) DESC
  LIMIT 50;
$$ LANGUAGE SQL STABLE SECURITY DEFINER;
