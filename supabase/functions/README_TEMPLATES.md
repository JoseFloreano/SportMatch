# Templates WhatsApp — SportMatch

Crear en: **business.facebook.com → WhatsApp Manager → Message Templates → Create**

Categoría: **Utility** (no Marketing — son notificaciones transaccionales).
Idioma: **Español (México) — `es_MX`**.

> Los templates deben aprobarse por Meta antes de poder usarse (24–48h).
> Mientras se aprueban, la app sigue funcionando: las llamadas a
> `notify-whatsapp` fallan con 500 (visible en logs) pero no bloquean el flujo.

---

## 1. `sesion_nueva_match`

Disparada por `match-users` al publicar una sesión.

**Body:**
```
Hay una sesión de {{1}} cerca de ti {{2}} en {{3}}.
Nivel: {{4}}. {{5}} lugar(es) disponible(s).
Abre SportMatch para unirte → https://sportmatch.app
```
**Params (5):** `[sport, hora, zona, nivel, spots]`

---

## 2. `alguien_se_unio`

Disparada por `joinSession` (notifica al host).

**Body:**
```
{{1}} quiere unirse a tu sesión de {{2}} ({{3}}).
Acepta o rechaza en SportMatch.
```
**Params (3):** `[nombre_participante, sport, hora]`

---

## 3. `participacion_aceptada`

Disparada por `acceptParticipant` (notifica al usuario aceptado).

**Body:**
```
¡{{1}} aceptó tu solicitud! Tu sesión de {{2}} es {{3}} en {{4}}.
Abre el chat para confirmar el punto exacto de encuentro.
```
**Params (4):** `[nombre_host, sport, hora, zona]`

---

## 4. `recordatorio_sesion`

(Sprint 3 / cron) — 1h antes de la sesión.

**Body:**
```
⏰ Recordatorio: tienes una sesión de {{1}} en 1 hora ({{2}}) con {{3}} en {{4}}.
¡No los dejes esperando!
```
**Params (4):** `[sport, hora, compañero, zona]`

---

## 5. `solicitar_rating`

Disparada por `request-ratings` (~2h después de la sesión).

**Body:**
```
¿Cómo estuvo tu sesión de {{1}} con {{2}}? Tu calificación ayuda a la comunidad.
Abre SportMatch para calificar (30 segundos).
```
**Params (2):** `[sport, nombre_compañero]`

---

## Tips para que Meta los apruebe rápido

- Categoría correcta: **Utility** (rechazan templates "transaccionales" con marketing).
- Cero emojis al inicio del mensaje (algunos países los penalizan).
- Los placeholders `{{N}}` van numerados y sin huecos.
- No prometas nada (ej. "ganaste un premio") — Meta lo lee como marketing.
- Si rechazan, ajusta el copy y reenvía; segunda revisión suele ser más rápida.
