// lib/core/env/env.dart
// Las variables se inyectan en compile time con:
//   flutter run   --dart-define-from-file=.env
//   flutter build apk --dart-define-from-file=.env
// NO usamos paquetes dotenv en runtime — leer compile-time es más seguro.

abstract class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );
  static const whatsappToken = String.fromEnvironment(
    'WHATSAPP_TOKEN',
    defaultValue: '',
  );
  static const whatsappPhoneNumberId = String.fromEnvironment(
    'WHATSAPP_PHONE_NUMBER_ID',
    defaultValue: '',
  );
  static const whatsappApiVersion = String.fromEnvironment(
    'WHATSAPP_API_VERSION',
    defaultValue: 'v19.0',
  );
  static const whatsappBusinessNumber = String.fromEnvironment(
    'WHATSAPP_BUSINESS_NUMBER',
    defaultValue: '',
  );
  static const googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );
  // double no tiene fromEnvironment const; lo leemos como String y parseamos.
  static const _defaultSearchRadiusKmRaw = String.fromEnvironment(
    'DEFAULT_SEARCH_RADIUS_KM',
    defaultValue: '3.0',
  );
  static double get defaultSearchRadiusKm =>
      double.tryParse(_defaultSearchRadiusKmRaw) ?? 3.0;
  static const reminderHoursBefore = int.fromEnvironment(
    'REMINDER_HOURS_BEFORE',
    defaultValue: 1,
  );
  static const ratingRequestHoursAfter = int.fromEnvironment(
    'RATING_REQUEST_HOURS_AFTER',
    defaultValue: 2,
  );
  static const appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction => appEnv == 'production';

  /// Lanza en debug si faltan las credenciales mínimas de Supabase.
  static void validate() {
    assert(
      supabaseUrl.isNotEmpty,
      'SUPABASE_URL no está definida. Corre con --dart-define-from-file=.env',
    );
    assert(
      supabaseAnonKey.isNotEmpty,
      'SUPABASE_ANON_KEY no está definida. Corre con --dart-define-from-file=.env',
    );
  }
}
