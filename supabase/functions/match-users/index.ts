// ─────────────────────────────────────────────────────────────
// match-users
// Dado un session_id, encuentra perfiles compatibles (deporte, nivel,
// proximidad opcional) y dispara notify-push (1 sola llamada) para que les
// llegue push notification + se les escriba la notificación en su feed.
//
// Body: { "session_id": "uuid" }
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

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (!req.headers.get("Authorization")) {
    return jsonResponse({ error: "Unauthorized" }, 401);
  }

  const { session_id } = await req.json().catch(() => ({}));
  if (!session_id) {
    return jsonResponse({ error: "session_id es requerido" }, 400);
  }

  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

  const { data: session, error: sErr } = await supabase
    .from("sessions")
    .select("id, sport, level, scheduled_at, zone_name, spots_available")
    .eq("id", session_id)
    .maybeSingle();

  if (sErr || !session) {
    return jsonResponse({ error: "Sesión no encontrada", details: sErr }, 404);
  }

  const { data: candidates, error: rErr } = await supabase.rpc(
    "find_match_candidates",
    { session_id_param: session_id, radius_km: 5.0, max_candidates: 20 },
  );

  if (rErr) {
    return jsonResponse(
      { error: "Error buscando candidatos", details: rErr },
      500,
    );
  }

  const rows = (candidates ?? []) as Array<{ user_id: string }>;
  if (rows.length === 0) {
    return jsonResponse({ notified: 0, candidates: 0 });
  }

  const sport = SPORT_LABELS[session.sport] ?? session.sport;
  const time = formatTime(new Date(session.scheduled_at));
  const title = `Sesión de ${sport} cerca de ti`;
  const body = `${session.zone_name} · ${time} · ` +
    `${session.spots_available} lugar${session.spots_available === 1 ? "" : "es"}`;

  const pushRes = await callNotifyPush({
    user_ids: rows.map((c) => c.user_id),
    type: "session_match",
    title,
    body,
    data: { session_id, route: `/session/${session_id}` },
  });

  return jsonResponse({ candidates: rows.length, push: pushRes });
});

async function callNotifyPush(body: Record<string, unknown>) {
  try {
    const res = await fetch(`${SUPABASE_URL}/functions/v1/notify-push`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });
    return { ok: res.ok, status: res.status };
  } catch (err) {
    console.warn("notify-push threw", err);
    return { ok: false, error: String(err) };
  }
}

function formatTime(dt: Date): string {
  const hours = dt.getUTCHours() - 6; // CDMX UTC-6
  const h = ((hours % 12 + 12) % 12) || 12;
  const m = dt.getUTCMinutes().toString().padStart(2, "0");
  const ampm = hours < 12 || hours >= 24 ? "am" : "pm";
  return `${h}:${m} ${ampm}`;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders },
  });
}
