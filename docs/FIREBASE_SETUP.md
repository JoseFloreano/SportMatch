# Firebase / FCM — Setup paso a paso

SportMatch usa **Firebase Cloud Messaging (FCM)** para push notifications.
Para Sprint 2 — solo Android (iOS llega después).

Tiempo estimado: **~15 minutos**.

---

## 1. Crear el proyecto Firebase

1. Ve a [console.firebase.google.com](https://console.firebase.google.com) → **Add project**.
2. Nombre: `sportmatch` (o el que prefieras). Google Analytics: opcional.
3. Una vez creado, en el menú izquierdo → **Project settings** (engranaje).

## 2. Registrar la app Android

1. En **Project settings → General → Your apps** → **Add app** → Android.
2. **Android package name** (debe coincidir con `applicationId`):
   ```
   com.sportmatch.sportmatch
   ```
3. **App nickname:** SportMatch Android (opcional).
4. **Debug signing certificate SHA-1:** opcional para FCM básico, requerido si más tarde activas Google Sign-In. Se saca con:
   ```bash
   cd android
   ./gradlew signingReport
   ```
5. **Descarga `google-services.json`** y colócalo en:
   ```
   android/app/google-services.json
   ```
   (Ya está en `.gitignore` — no se sube al repo.)

## 3. Service account JSON (para las Edge Functions)

1. En **Project settings → Service accounts** → **Generate new private key** → confirma.
2. Se descarga un archivo `sportmatch-firebase-adminsdk-XXXXX.json`.
3. **El contenido completo del JSON** se sube como secret de Supabase:
   ```bash
   # PowerShell (Windows):
   $json = Get-Content sportmatch-firebase-adminsdk-XXXXX.json -Raw
   supabase secrets set FIREBASE_SERVICE_ACCOUNT_JSON="$json"

   # Bash:
   supabase secrets set FIREBASE_SERVICE_ACCOUNT_JSON="$(cat sportmatch-firebase-adminsdk-XXXXX.json)"
   ```
4. **Borra el JSON local** una vez subido (es la llave maestra).

## 4. Habilitar Cloud Messaging API (V1)

Solo si Google no la habilitó automáticamente:
1. En la [Google Cloud Console](https://console.cloud.google.com/apis/library) selecciona tu proyecto.
2. Busca **Firebase Cloud Messaging API** → **Enable**.

## 5. Correr las migraciones SQL

En Supabase Dashboard → SQL Editor, ejecuta:
- [`supabase/migrations/003_push_and_notifications.sql`](../supabase/migrations/003_push_and_notifications.sql)

Esto crea las tablas `notifications` y `profile_push_tokens` + RPCs.

## 6. Deploy de las Edge Functions

```bash
supabase functions deploy notify-push
supabase functions deploy match-users      # reemplaza la versión Sprint 2
supabase functions deploy request-ratings  # reemplaza la versión Sprint 2
```

## 7. Programar el cron de ratings

Dashboard → Edge Functions → `request-ratings` → **Schedule** → cron `0 * * * *`.

## 8. Probar end-to-end

```bash
flutter run --dart-define-from-file=.env
```

Login con el número de prueba, otorga permiso de notificaciones. La primera vez la app sube el token FCM al perfil. Luego desde otro dispositivo (o desde la app misma como otro usuario) publica una sesión → en ~5 segundos te llega el push **y** aparece en `/notifications`.

## Troubleshooting

| Síntoma | Causa probable | Fix |
|---|---|---|
| App crashea al arrancar con `MissingPluginException` | Falta `google-services.json` | Descárgalo y colócalo en `android/app/` |
| Token FCM nunca se sube | Usuario no dio permiso (Android 13+) | Ve a Ajustes del sistema → SportMatch → Notificaciones |
| Edge Function responde 200 pero no llega push | `FIREBASE_SERVICE_ACCOUNT_JSON` no seteado | `supabase secrets list` para verificar |
| `FCM rejected token` en logs | Token caducado | El cliente lo regenera automáticamente al siguiente arranque; la function ya borra los inválidos |
| Notificación llega pero el tap no abre la pantalla | Payload sin campo `route` | Las funciones ya lo incluyen; revisa que `notify-push` esté actualizado |
