// ─────────────────────────────────────────────────────────────
// request-ratings
// Cron job (Dashboard → Edge Functions → Schedule: 0 * * * *).
// Encuentra participantes de sesiones completadas hace >= 2h pendientes de
// calificar, dispara notify-push, y guarda en rating_requests para no
// duplicar.
// ─────────────────────────────────────────────────────────────

import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// CORS inline (el dashboard no bundlea archivos vecinos como _shared/).
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
};

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const HOURS_AFTER = Number(Deno.env.get("RATING_REQUEST_HOURS_AFTER") ?? "2");

const SPORT_LABELS: Record<string, string> = {
  crossfit: "CrossFit",
  calistenia: "Calistenia",
  hiit: "HIIT",
  kettlebell: "Kettlebell",
  running: "Running",
  tenis: "Tenis",
  yoga: "Yoga",
  futbol: "Fútbol",
};

serve(async (_req: Request) => {
  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

  const { data: targets, error } = await supabase.rpc(
    "pending_rating_targets",
    { hours_after: HOURS_AFTER },
  );

  if (error) {
    console.error("pending_rating_targets failed", error);
    return jsonResponse({ error: "DB error", details: error }, 500);
  }

  const rows = (targets ?? []) as Array<{
    session_id: string;
    user_id: string;
    sport: string;
    companion_name: string;
  }>;

  let sent = 0;
  for (const t of rows) {
    const sport = SPORT_LABELS[t.sport] ?? t.sport;
    const ok = await callNotifyPush({
      user_id: t.user_id,
      type: "rate_request",
      title: `Califica tu sesión de ${sport}`,
      body: `¿Cómo estuvo con ${t.companion_name}? Toma 30 segundos.`,
      data: { session_id: t.session_id, route: `/rate/${t.session_id}` },
    });

    if (ok) {
      await supabase.from("rating_requests").insert({
        session_id: t.session_id,
        user_id: t.user_id,
      });
      sent++;
    }
  }

  return jsonResponse({ targets: rows.length, sent });
});

async function callNotifyPush(body: Record<string, unknown>): Promise<boolean> {
  try {
    const res = await fetch(`${SUPABASE_URL}/functions/v1/notify-push`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });
    return res.ok;
  } catch (err) {
    console.warn("notify-push threw", err);
    return false;
  }
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders },
  });
}
