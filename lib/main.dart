import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env/env.dart';
import 'core/services/push_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.validate();

  // Inicializa el formateo de fechas en español (DateFormat es_MX).
  await initializeDateFormatting('es_MX');

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 40,
    ),
  );

  // Firebase es opcional para arrancar (si falta google-services.json la app
  // sigue corriendo sin push). PushService devuelve false en ese caso.
  await PushService.initFirebase();

  runApp(const ProviderScope(child: SportMatchApp()));
}
