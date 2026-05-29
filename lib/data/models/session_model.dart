import '../../core/constants/app_constants.dart';
import 'profile_model.dart';

class SessionModel {
  final String id;
  final String hostId;
  final String sport;
  final String level;
  final DateTime scheduledAt;
  final int durationMin;
  final int maxSpots;
  final int spotsAvailable;
  final String zoneName;
  final double lat;
  final double lng;
  final String? notes;
  final bool womenOnly;
  final String status; // "open" | "full" | "confirmed" | "completed" | "cancelled"
  final ProfileModel? host; // JOIN con profiles (nullable)
  final double? distanceM; // distancia desde el usuario (RPC PostGIS)
  final DateTime createdAt;

  const SessionModel({
    required this.id,
    required this.hostId,
    required this.sport,
    required this.level,
    required this.scheduledAt,
    this.durationMin = 60,
    required this.maxSpots,
    required this.spotsAvailable,
    required this.zoneName,
    required this.lat,
    required this.lng,
    this.notes,
    this.womenOnly = false,
    this.status = 'open',
    this.host,
    this.distanceM,
    required this.createdAt,
  });

  bool get isFull => spotsAvailable <= 0;
  bool get isOpen => status == 'open';
  bool get isEvent => false;
  String get sportEmoji => AppConstants.sportEmoji(sport);
  String get sportLabel => AppConstants.sportLabel(sport);

  /// Distancia legible en km (ej. "0.4 km") si está disponible.
  String? get distanceLabel {
    if (distanceM == null) return null;
    final km = distanceM! / 1000.0;
    return '${km.toStringAsFixed(km < 10 ? 1 : 0)} km';
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    // PostGIS retorna location como WKT: "POINT(-99.1630 19.4193)".
    // Para evitar parsear WKT en cliente, guardamos lat/lng como columnas
    // y la RPC get_nearby_sessions las retorna directamente.
    double lat = 0.0;
    double lng = 0.0;
    if (map['lat'] != null && map['lng'] != null) {
      lat = (map['lat'] as num).toDouble();
      lng = (map['lng'] as num).toDouble();
    }

    // El host puede venir como objeto anidado (JOIN) o como columnas planas
    // (RPC get_nearby_sessions: host_name, host_rating, host_avatar...).
    ProfileModel? host;
    if (map['host'] != null) {
      host = ProfileModel.fromMap(map['host'] as Map<String, dynamic>);
    } else if (map['host_name'] != null) {
      host = ProfileModel(
        id: map['host_id'] as String,
        displayName: map['host_name'] as String,
        phone: '',
        avatarUrl: map['host_avatar'] as String?,
        rating: (map['host_rating'] as num?)?.toDouble() ?? 0.0,
        attendanceRate: (map['host_attendance'] as num?)?.toDouble() ?? 100.0,
        createdAt: DateTime.now(),
      );
    }

    return SessionModel(
      id: map['id'] as String,
      hostId: map['host_id'] as String,
      sport: map['sport'] as String,
      level: map['level'] as String,
      scheduledAt: DateTime.parse(map['scheduled_at'] as String),
      durationMin: (map['duration_min'] as num?)?.toInt() ?? 60,
      maxSpots: (map['max_spots'] as num).toInt(),
      spotsAvailable: (map['spots_available'] as num).toInt(),
      zoneName: map['zone_name'] as String,
      lat: lat,
      lng: lng,
      notes: map['notes'] as String?,
      womenOnly: map['women_only'] as bool? ?? false,
      status: map['status'] as String? ?? 'open',
      host: host,
      distanceM: (map['distance_m'] as num?)?.toDouble(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }
}
