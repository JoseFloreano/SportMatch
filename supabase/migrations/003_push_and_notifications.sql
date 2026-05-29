-- ═══════════════════════════════════════════════════════════
-- SportMatch — Push notifications (FCM) + in-app notifications
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- ═══════════════════════════════════════════════════════════

-- ── PROFILE PUSH TOKENS ─────────────────────────────────────
-- Un usuario puede tener varios devices (Android + iOS futuro), por eso
-- la PK es (user_id, fcm_token).
CREATE TABLE IF NOT EXISTS public.profile_push_tokens (
  user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  fcm_token   TEXT NOT NULL,
  platform    TEXT NOT NULL DEFAULT 'android'
              CHECK (platform IN ('android','ios','web')),
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, fcm_token)
);

ALTER TABLE public.profile_push_tokens ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "push_tokens_own_select" ON public.profile_push_tokens;
CREATE POLICY "push_tokens_own_select" ON public.profile_push_tokens
  FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "push_tokens_own_insert" ON public.profile_push_tokens;
CREATE POLICY "push_tokens_own_insert" ON public.profile_push_tokens
  FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "push_tokens_own_update" ON public.profile_push_tokens;
CREATE POLICY "push_tokens_own_update" ON public.profile_push_tokens
  FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "push_tokens_own_delete" ON public.profile_push_tokens;
CREATE POLICY "push_tokens_own_delete" ON public.profile_push_tokens
  FOR DELETE USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS push_tokens_user_idx
  ON public.profile_push_tokens(user_id);

-- RPC para que la app suba/actualice su token sin tocar la tabla directo.
CREATE OR REPLACE FUNCTION public.register_push_token(
  p_token    TEXT,
  p_platform TEXT DEFAULT 'android'
)
RETURNS VOID AS $$
  INSERT INTO public.profile_push_tokens (user_id, fcm_token, platform)
  VALUES (auth.uid(), p_token, p_platform)
  ON CONFLICT (user_id, fcm_token)
    DO UPDATE SET updated_at = NOW(), platform = EXCLUDED.platform;
$$ LANGUAGE SQL SECURITY DEFINER;

-- ── NOTIFICATIONS (in-app feed) ─────────────────────────────
CREATE TABLE IF NOT EXISTS public.notifications (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  type        TEXT NOT NULL,           -- 'session_match','someone_joined','accepted','rate_request'
  title       TEXT NOT NULL,
  body        TEXT NOT NULL,
  data        JSONB DEFAULT '{}',      -- payload arbitrario (session_id, etc.)
  read_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS notifications_user_unread_idx
  ON public.notifications(user_id, read_at)
  WHERE read_at IS NULL;

CREATE INDEX IF NOT EXISTS notifications_user_created_idx
  ON public.notifications(user_id, created_at DESC);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "notifications_own_select" ON public.notifications;
CREATE POLICY "notifications_own_select" ON public.notifications
  FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "notifications_own_update" ON public.notifications;
CREATE POLICY "notifications_own_update" ON public.notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- Las inserts las hace la Edge Function notify-push con service-role.

ALTER TABLE public.notifications REPLICA IDENTITY FULL;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

-- RPC para marcar como leídas.
CREATE OR REPLACE FUNCTION public.mark_notifications_read(p_ids UUID[])
RETURNS VOID AS $$
  UPDATE public.notifications
  SET read_at = NOW()
  WHERE id = ANY(p_ids) AND user_id = auth.uid();
$$ LANGUAGE SQL SECURITY DEFINER;

-- RPC para marcar todas como leídas.
CREATE OR REPLACE FUNCTION public.mark_all_notifications_read()
RETURNS VOID AS $$
  UPDATE public.notifications
  SET read_at = NOW()
  WHERE user_id = auth.uid() AND read_at IS NULL;
$$ LANGUAGE SQL SECURITY DEFINER;
