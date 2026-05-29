-- ═══════════════════════════════════════════════════════════
-- SportMatch — Seed de 10 eventos patrocinados (CDMX)
-- Ejecutar en: Supabase Dashboard → SQL Editor (después de las migraciones).
-- Idempotente: usa UUIDs fijos + ON CONFLICT DO NOTHING (re-ejecutable).
-- sponsor_id = NULL (eventos demo sin perfil dueño).
-- scheduled_at relativo a NOW() para que siempre estén "próximos".
-- ═══════════════════════════════════════════════════════════

INSERT INTO public.events
  (id, sponsor_id, title, sport, description, location, lat, lng,
   venue_name, venue_address, scheduled_at, duration_min, max_capacity,
   spots_rx, spots_scaled, spots_beginner, price_mxn, wod_description,
   is_sponsored, status)
VALUES
  -- 1. Box Alpha Condesa (CrossFit) — el del mockup
  ('a5e10001-0000-4000-8000-000000000001', NULL,
   'CrossFit Abierto — Box Alpha', 'crossfit',
   'WOD grupal de 90 min patrocinado por Box Alpha. Coach certificado, barras y pesas incluidas. Matching por nivel.',
   ST_MakePoint(-99.1730, 19.4100)::geography, 19.4100, -99.1730,
   'Box Alpha Condesa', 'Tamaulipas 95, Condesa', NOW() + INTERVAL '2 days',
   90, 20, 4, 8, 4, 0,
   '[{"reps":"21","name":"Thrusters","note":"RX: 43kg · Scaled: 29kg"},{"reps":"15","name":"Pull-ups","note":"RX: strict · Scaled: banded"},{"reps":"9","name":"Box Jumps","note":"RX: 24\" · Scaled: 20\""}]'::jsonb,
   TRUE, 'open'),

  -- 2. Smart Fit Condesa (HIIT)
  ('a5e10001-0000-4000-8000-000000000002', NULL,
   'HIIT Express by Smart Fit', 'hiit',
   'Sesión HIIT de 45 min en Smart Fit Condesa. Clase de prueba gratuita para nuevos miembros.',
   ST_MakePoint(-99.1760, 19.4125)::geography, 19.4125, -99.1760,
   'Smart Fit Condesa', 'Av. Tamaulipas 66, Hipódromo', NOW() + INTERVAL '1 day',
   45, 25, 0, 15, 10, 0, '[]'::jsonb, TRUE, 'open'),

  -- 3. Gatorade Running (Chapultepec)
  ('a5e10001-0000-4000-8000-000000000003', NULL,
   'Gatorade Run Series 10K', 'running',
   'Carrera 10K patrocinada por Gatorade en Bosque de Chapultepec. Hidratación y kit incluidos.',
   ST_MakePoint(-99.1817, 19.4204)::geography, 19.4204, -99.1817,
   'Bosque de Chapultepec', '1a Sección, Chapultepec', NOW() + INTERVAL '5 days',
   60, 100, 0, 0, 0, 0, '[]'::jsonb, TRUE, 'open'),

  -- 4. Sport City Polanco (HIIT)
  ('a5e10001-0000-4000-8000-000000000004', NULL,
   'Bootcamp Sport City', 'hiit',
   'Bootcamp funcional en Sport City Polanco. Equipo completo y entrenador.',
   ST_MakePoint(-99.1986, 19.4339)::geography, 19.4339, -99.1986,
   'Sport City Polanco', 'Av. Moliere 222, Polanco', NOW() + INTERVAL '3 days',
   60, 30, 0, 18, 12, 50, '[]'::jsonb, TRUE, 'open'),

  -- 5. Nike Run Club Reforma (Running)
  ('a5e10001-0000-4000-8000-000000000005', NULL,
   'Nike Run Club Reforma', 'running',
   'Rodada nocturna 8K sobre Paseo de la Reforma con pacers de Nike Run Club.',
   ST_MakePoint(-99.1677, 19.4270)::geography, 19.4270, -99.1677,
   'Ángel de la Independencia', 'Paseo de la Reforma, Juárez', NOW() + INTERVAL '4 days',
   75, 60, 0, 0, 0, 0, '[]'::jsonb, TRUE, 'open'),

  -- 6. Under Armour Training (Kettlebell, Del Valle)
  ('a5e10001-0000-4000-8000-000000000006', NULL,
   'UA Kettlebell Lab', 'kettlebell',
   'Clínica de kettlebell con técnica de swing y turkish get-up. Patrocina Under Armour.',
   ST_MakePoint(-99.1665, 19.3905)::geography, 19.3905, -99.1665,
   'UA Training Center', 'Av. Coyoacán 1435, Del Valle', NOW() + INTERVAL '6 days',
   60, 16, 4, 8, 4, 80, '[]'::jsonb, TRUE, 'open'),

  -- 7. Calistenia Coyoacán (Calistenia)
  ('a5e10001-0000-4000-8000-000000000007', NULL,
   'Street Workout Coyoacán', 'calistenia',
   'Sesión de calistenia en parque equipado. Front lever, muscle-up y pistol squat por nivel.',
   ST_MakePoint(-99.1620, 19.3500)::geography, 19.3500, -99.1620,
   'Parque Calistenia Coyoacán', 'Av. Universidad, Coyoacán', NOW() + INTERVAL '2 days',
   60, 20, 6, 8, 6, 0, '[]'::jsonb, TRUE, 'open'),

  -- 8. Smart Fit Narvarte (HIIT)
  ('a5e10001-0000-4000-8000-000000000008', NULL,
   'Funcional Smart Fit Narvarte', 'hiit',
   'Circuito funcional de 50 min. Clase abierta patrocinada por Smart Fit.',
   ST_MakePoint(-99.1560, 19.3950)::geography, 19.3950, -99.1560,
   'Smart Fit Narvarte', 'Av. Cuauhtémoc 1235, Narvarte', NOW() + INTERVAL '1 day',
   50, 25, 0, 15, 10, 0, '[]'::jsonb, TRUE, 'open'),

  -- 9. Powerade Endurance (Running, CU)
  ('a5e10001-0000-4000-8000-000000000009', NULL,
   'Powerade Endurance Trail', 'running',
   'Trail 12K en Ciudad Universitaria con estaciones de hidratación Powerade.',
   ST_MakePoint(-99.1870, 19.3320)::geography, 19.3320, -99.1870,
   'Ciudad Universitaria', 'Circuito Escolar, CU', NOW() + INTERVAL '7 days',
   90, 80, 0, 0, 0, 0, '[]'::jsonb, TRUE, 'open'),

  -- 10. CrossFit Roma (CrossFit)
  ('a5e10001-0000-4000-8000-000000000010', NULL,
   'Hero WOD — CrossFit Roma', 'crossfit',
   'Hero WOD "Murph" adaptado por nivel. Patrocina CrossFit Roma con coach y barras.',
   ST_MakePoint(-99.1605, 19.4187)::geography, 19.4187, -99.1605,
   'CrossFit Roma', 'Álvaro Obregón 200, Roma Norte', NOW() + INTERVAL '3 days',
   90, 24, 6, 10, 8, 0,
   '[{"reps":"1 mi","name":"Run","note":"RX: con chaleco · Scaled: sin chaleco"},{"reps":"100","name":"Pull-ups","note":"Scaled: banded"},{"reps":"200","name":"Push-ups","note":"Scaled: rodillas"},{"reps":"300","name":"Air Squats","note":""}]'::jsonb,
   TRUE, 'open')
ON CONFLICT (id) DO NOTHING;
