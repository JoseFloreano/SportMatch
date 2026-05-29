// ─────────────────────────────────────────────────────────────
// notify-push
// 1) Inserta filas en public.notifications (feed in-app).
// 2) Manda push via Firebase Cloud Messaging HTTP v1 a los tokens
//    registrados de cada usuario.
//
// Body (JSON):
//   {
//     "user_ids":  ["uuid", ...]   // o "user_id": "uuid"
//     "type":      "someone_joined",
//     "title":     "Nueva solicitud",
//     "body":      "Mariana quiere unirse a tu sesión de CrossFit",
//     "data":      { "session_id": "uuid", "route": "/session/uuid" }  // opcional
//   }
//
// Secrets requeridos:
//   FIREBASE_SERVICE_ACCOUNT_JSON   — JSON completo descargado de Firebase
//                                     Console → Settings → Service accounts.
//   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY (default en Supabase)
// ─────────────────────────────────────────────────────────────

import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { JWT } from "npm:google-auth-library@9";

// CORS inline (el dashboard no bundlea archivos vecinos como _shared/).
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
};

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const FIREBASE_JSON = Deno.env.get("FIREBASE_SERVICE_ACCOUNT_JSON") ?? "";

interface Payload {
  user_id?: string;
  user_ids?: string[];
  type: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}

// Cache del access token de Google. FCM tokens duran 1h.
let cachedToken: { token: string; expiresAt: number } | null = null;

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (!req.headers.get("Authorization")) {
    return jsonResponse({ error: "Unauthorized" }, 401);
  }

  let payload: Payload;
  try {
    payload = await req.json();
  } catch {
    return jsonResponse({ error: "Invalid JSON body" }, 400);
  }

  const userIds = payload.user_ids ??
    (payload.user_id ? [payload.user_id] : []);
  if (
    userIds.length === 0 || !payload.type || !payload.title || !payload.body
  ) {
    return jsonResponse(
      { error: "user_id(s), type, title, body son requeridos" },
      400,
    );
  }

  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

  // 1. Inserta en notifications (feed in-app).
  const rows = userIds.map((uid) => ({
    user_id: uid,
    type: payload.type,
    title: payload.title,
    body: payload.body,
    data: payload.data ?? {},
  }));
  const { error: insErr } = await supabase.from("notifications").insert(rows);
  if (insErr) {
    console.error("Failed inserting notifications", insErr);
  }

  // 2. Si no hay credenciales de Firebase, devolvemos solo con el feed.
  if (!FIREBASE_JSON) {
    return jsonResponse({
      ok: true,
      pushed: 0,
      note: "FIREBASE_SERVICE_ACCOUNT_JSON not configured; only in-app saved.",
    });
  }

  // 3. Trae todos los tokens de los usuarios destino.
  const { data: tokenRows, error: tokErr } = await supabase
    .from("profile_push_tokens")
    .select("user_id, fcm_token, platform")
    .in("user_id", userIds);

  if (tokErr) {
    return jsonResponse(
      { error: "Failed reading push tokens", details: tokErr },
      500,
    );
  }

  const tokens = (tokenRows ?? []) as Array<{ fcm_token: string }>;
  if (tokens.length === 0) {
    return jsonResponse({ ok: true, pushed: 0, note: "No tokens registered" });
  }

  // 4. Saca un access token de Google para FCM HTTP v1.
  let accessToken: string;
  let projectId: string;
  try {
    const result = await getFcmAccessToken();
    accessToken = result.token;
    projectId = result.projectId;
  } catch (e) {
    console.error("Failed obtaining FCM access token", e);
    return jsonResponse({ error: "FCM auth error", details: String(e) }, 500);
  }

  const fcmUrl =
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;

  let pushed = 0;
  const failed: string[] = [];

  await Promise.all(tokens.map(async ({ fcm_token }) => {
    try {
      const res = await fetch(fcmUrl, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          message: {
            token: fcm_token,
            notification: { title: payload.title, body: payload.body },
            data: stringifyValues(payload.data ?? {}),
            android: {
              priority: "HIGH",
              notification: { channel_id: "sportmatch_default" },
            },
          },
        }),
      });
      if (res.ok) {
        pushed++;
      } else {
        const errBody = await res.text();
        console.warn("FCM rejected token", fcm_token.slice(0, 12), errBody);
        failed.push(fcm_token);
        // Si el token está caducado/inválido, lo borramos.
        if (
          res.status === 404 || errBody.includes("UNREGISTERED") ||
          errBody.includes("INVALID_ARGUMENT")
        ) {
          await supabase.from("profile_push_tokens")
            .delete()
            .eq("fcm_token", fcm_token);
        }
      }
    } catch (e) {
      console.warn("FCM fetch threw", e);
      failed.push(fcm_token);
    }
  }));

  return jsonResponse({
    ok: true,
    in_app: userIds.length,
    pushed,
    failed: failed.length,
  });
});

async function getFcmAccessToken(): Promise<
  { token: string; projectId: string }
> {
  const credentials = JSON.parse(FIREBASE_JSON) as {
    client_email: string;
    private_key: string;
    project_id: string;
  };

  // Reusar si no ha caducado (renueva 5 min antes de expirar).
  const now = Date.now();
  if (cachedToken && cachedToken.expiresAt - 5 * 60_000 > now) {
    return { token: cachedToken.token, projectId: credentials.project_id };
  }

  const client = new JWT({
    email: credentials.client_email,
    key: credentials.private_key,
    scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
  });
  const { token, res } = await client.getAccessToken();
  if (!token) throw new Error("No access token returned from Google");
  // El SDK no expone expiry directamente; asumimos 50 min para estar a salvo.
  const expiresAt = now + 50 * 60_000;
  cachedToken = { token, expiresAt };
  // res.data?.expires_in podría existir; lo ignoramos para simplicidad.
  void res;
  return { token, projectId: credentials.project_id };
}

/** FCM solo acepta strings en `data`. Convertimos cualquier value a string. */
function stringifyValues(obj: Record<string, unknown>): Record<string, string> {
  const out: Record<string, string> = {};
  for (const [k, v] of Object.entries(obj)) {
    out[k] = typeof v === "string" ? v : JSON.stringify(v);
  }
  return out;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders },
  });
}
