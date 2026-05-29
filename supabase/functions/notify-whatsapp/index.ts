// ─────────────────────────────────────────────────────────────
// notify-whatsapp
// Envía un mensaje a un teléfono usando un template de WhatsApp Cloud API.
//
// Body (JSON):
//   {
//     "to_phone": "5215512345678",
//     "template_name": "alguien_se_unio",
//     "params": ["Mariana", "CrossFit", "7:00 am"],
//     "language": "es_MX"   // opcional, default es_MX
//   }
//
// Variables (Supabase secrets):
//   WHATSAPP_TOKEN              — System User Token de Meta
//   WHATSAPP_PHONE_NUMBER_ID    — ID del número de WhatsApp Business
//   WHATSAPP_API_VERSION        — ej. v19.0 (default si falta)
//
// Deploy:
//   supabase functions deploy notify-whatsapp
//   supabase secrets set WHATSAPP_TOKEN=EAAxxx WHATSAPP_PHONE_NUMBER_ID=123 \
//                       WHATSAPP_API_VERSION=v19.0
// ─────────────────────────────────────────────────────────────

import { serve } from "https://deno.land/std@0.208.0/http/server.ts";

// CORS inline (el dashboard no bundlea archivos vecinos como _shared/).
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
};

interface NotifyPayload {
  to_phone: string;
  template_name: string;
  params: string[];
  language?: string;
}

const WHATSAPP_TOKEN = Deno.env.get("WHATSAPP_TOKEN") ?? "";
const PHONE_NUMBER_ID = Deno.env.get("WHATSAPP_PHONE_NUMBER_ID") ?? "";
const WA_VERSION = Deno.env.get("WHATSAPP_API_VERSION") ?? "v19.0";

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // Requiere autorización (JWT del usuario o service role).
  if (!req.headers.get("Authorization")) {
    return jsonResponse({ error: "Unauthorized" }, 401);
  }

  if (!WHATSAPP_TOKEN || !PHONE_NUMBER_ID) {
    return jsonResponse(
      { error: "WhatsApp credentials missing in environment." },
      500,
    );
  }

  let payload: NotifyPayload;
  try {
    payload = await req.json();
  } catch {
    return jsonResponse({ error: "Invalid JSON body" }, 400);
  }

  if (!payload.to_phone || !payload.template_name) {
    return jsonResponse(
      { error: "to_phone y template_name son requeridos" },
      400,
    );
  }

  const components = payload.params.length > 0
    ? [
      {
        type: "body",
        parameters: payload.params.map((p) => ({ type: "text", text: p })),
      },
    ]
    : [];

  const url =
    `https://graph.facebook.com/${WA_VERSION}/${PHONE_NUMBER_ID}/messages`;

  let waResponse: Response;
  try {
    waResponse = await fetch(url, {
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
          components,
        },
      }),
    });
  } catch (err) {
    console.error("Fetch to WhatsApp failed", err);
    return jsonResponse({ error: "Network error contacting WhatsApp" }, 502);
  }

  let data: Record<string, unknown> = {};
  try {
    data = await waResponse.json();
  } catch {
    // ignoramos parse error; data queda vacío
  }

  if (!waResponse.ok) {
    console.error("WhatsApp API error", JSON.stringify(data));
    return jsonResponse({ error: "WhatsApp API error", details: data }, 500);
  }

  return jsonResponse({
    success: true,
    message_id: (data as { messages?: Array<{ id?: string }> }).messages?.[0]
      ?.id,
  });
});

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...corsHeaders },
  });
}
