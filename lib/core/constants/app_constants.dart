abstract class AppConstants {
  // Deportes disponibles (nicho funcional primero)
  static const List<Map<String, String>> sports = [
    {'id': 'crossfit', 'label': 'CrossFit', 'emoji': '💪'},
    {'id': 'gym', 'label': 'Gym', 'emoji': '🏋️'},
    {'id': 'calistenia', 'label': 'Calistenia', 'emoji': '🤸'},
    {'id': 'hiit', 'label': 'HIIT', 'emoji': '⚡'},
    {'id': 'kettlebell', 'label': 'Kettlebell', 'emoji': '🎯'},
    {'id': 'running', 'label': 'Running', 'emoji': '🏃'},
    {'id': 'tenis', 'label': 'Tenis', 'emoji': '🎾'},
    {'id': 'yoga', 'label': 'Yoga', 'emoji': '🧘'},
  ];

  // Niveles de deporte funcional
  static const List<Map<String, String>> levels = [
    {'id': 'rx', 'label': 'RX', 'desc': 'Competitivo'},
    {'id': 'scaled', 'label': 'Scaled', 'desc': 'Intermedio'},
    {'id': 'beginner', 'label': 'Beginner', 'desc': 'Iniciando'},
    {'id': 'any', 'label': 'Todos', 'desc': 'Cualquier nivel'},
  ];

  // Centro del mapa por default: La Condesa, CDMX
  static const double defaultLat = 19.4116;
  static const double defaultLng = -99.1751;
  static const double defaultZoom = 15.0;

  // Horas para disparar recordatorio y rating
  static const int reminderHoursBefore = 1;
  static const int ratingHoursAfter = 2;
  static const int maxSpotsPerSession = 8;

  /// Emoji del deporte por id (fallback corredor).
  static String sportEmoji(String sportId) {
    return sports.firstWhere(
      (s) => s['id'] == sportId,
      orElse: () => const {'emoji': '🏃'},
    )['emoji']!;
  }

  /// Label legible del deporte por id.
  static String sportLabel(String sportId) {
    return sports.firstWhere(
      (s) => s['id'] == sportId,
      orElse: () => {'label': sportId},
    )['label']!;
  }

  // WA phone format México
  static String formatMxPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('52')) return cleaned;
    if (cleaned.startsWith('1')) return '52$cleaned';
    return '521$cleaned'; // Agrega lada internacional
  }
}
