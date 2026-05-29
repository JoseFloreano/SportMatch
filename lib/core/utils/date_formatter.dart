import 'package:intl/intl.dart';

/// Formateo de fechas en español para la UI deportiva (directo, pocas palabras).
abstract class DateFormatter {
  /// "7:00 am"
  static String time(DateTime dt) =>
      DateFormat('h:mm a', 'es_MX').format(dt.toLocal()).toLowerCase();

  /// "Hoy", "Mañana" o "lun 12 may".
  static String relativeDay(DateTime dt) {
    final now = DateTime.now();
    final d = DateTime(dt.year, dt.month, dt.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = d.difference(today).inDays;
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Mañana';
    if (diff == -1) return 'Ayer';
    return DateFormat('EEE d MMM', 'es_MX').format(dt.toLocal());
  }

  /// "Mañana · 7:00 am"
  static String dayAndTime(DateTime dt) => '${relativeDay(dt)} · ${time(dt)}';

  /// "12 may 2025"
  static String shortDate(DateTime dt) =>
      DateFormat('d MMM yyyy', 'es_MX').format(dt.toLocal());
}
