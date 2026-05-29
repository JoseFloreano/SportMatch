# SportMatch — Supabase Edge Functions

Functions Deno/TypeScript que orquestan notificaciones:

| Función              | Disparo                              | Propósito                                                       |
|----------------------|--------------------------------------|-----------------------------------------------------------------|
| `notify-push`        | Invocada por la app o por otras Edge | Inserta en `notifications` + manda push via FCM HTTP v1         |
| `match-users`        | App al publicar sesión               | Encuentra compatibles cercanos y llama `notify-push` con todos  |
| `request-ratings`    | Cron (cada hora)                     | Pide rating a participantes de sesiones completadas (+2h)       |
| `notify-whatsapp`    | (parqueada)                          | WhatsApp Cloud API — disponible cuando aprueben los templates   |

## Deploy

Pre-requisito: [Supabase CLI](https://supabase.com/docs/guides/cli) instalado y `supabase link --project-ref TU_REF` ejecutado.

```bash
supabase functions deploy notify-push
supabase functions deploy match-users
supabase functions deploy request-ratings
# Opcional cuando aprueben los templates de Meta:
# supabase functions deploy notify-whatsapp
```

## Secrets

Las credenciales **NO** van al repo. Configúralas con:

```bash
# Push (Firebase) — ver docs/FIREBASE_SETUP.md
supabase secrets set FIREBASE_SERVICE_ACCOUNT_JSON="$(cat firebase-admin.json)"
supabase secrets set RATING_REQUEST_HOURS_AFTER=2

# WhatsApp (opcional, cuando aprueben templates)
supabase secrets set \
  WHATSAPP_TOKEN=EAAxxx... \
  WHATSAPP_PHONE_NUMBER_ID=123456789012345 \
  WHATSAPP_API_VERSION=v19.0
```

`SUPABASE_URL` y `SUPABASE_SERVICE_ROLE_KEY` ya están disponibles para las functions por default.

## Schedule del cron de ratings

Dashboard → Edge Functions → `request-ratings` → **Schedule** → cron `0 * * * *` (cada hora en punto).

## Templates de WhatsApp

Antes de poder mandar mensajes, los 5 templates documentados en
[`README_TEMPLATES.md`](README_TEMPLATES.md) tienen que estar **aprobados por Meta**
(24–48h). Mientras tanto, la app no rompe: las invocaciones a `notify-whatsapp`
fallarán con un 500 (registrado en logs) pero no bloquean la operación principal
(unirse, crear sesión, etc.) — se hacen *fire-and-forget*.
