import '../../core/constants/app_constants.dart';

class EventModel {
  final String id;
  final String? sponsorId;
  final String title;
  final String sport;
  final String? description;
  final double lat;
  final double lng;
  final String venueName;
  final String? venueAddress;
  final DateTime scheduledAt;
  final int durationMin;
  final int maxCapacity;
  final int spotsRx;
  final int spotsScaled;
  final int spotsBeginner;
  final double priceMxn;
  final List<Map<String, dynamic>> wodDescription;
  final bool isSponsored;
  final String status; // "open" | "full" | "completed" | "cancelled"
  final double? distanceM;
  final DateTime createdAt;

  const EventModel({
    required this.id,
    this.sponsorId,
    required this.title,
    required this.sport,
    this.description,
    required this.lat,
    required this.lng,
    required this.venueName,
    this.venueAddress,
    required this.scheduledAt,
    this.durationMin = 90,
    this.maxCapacity = 20,
    this.spotsRx = 0,
    this.spotsScaled = 0,
    this.spotsBeginner = 0,
    this.priceMxn = 0,
    this.wodDescription = const [],
    this.isSponsored = true,
    this.status = 'open',
    this.distanceM,
    required this.createdAt,
  });

  bool get isEvent => true;
  int get spotsAvailable => spotsRx + spotsScaled + spotsBeginner;
  bool get isFull => spotsAvailable <= 0;
  String get sportEmoji => AppConstants.sportEmoji(sport);
  String get priceLabel => priceMxn <= 0 ? '\$0' : '\$${priceMxn.toStringAsFixed(0)}';

  factory EventModel.fromMap(Map<String, dynamic> map) {
    double lat = 0.0;
    double lng = 0.0;
    if (map['lat'] != null && map['lng'] != null) {
      lat = (map['lat'] as num).toDouble();
      lng = (map['lng'] as num).toDouble();
    }

    // wod_description es JSONB; puede venir como List<dynamic> de Maps.
    final rawWod = map['wod_description'];
    final wod = <Map<String, dynamic>>[];
    if (rawWod is List) {
      for (final item in rawWod) {
        if (item is Map) wod.add(Map<String, dynamic>.from(item));
      }
    }

    return EventModel(
      id: map['id'] as String,
      sponsorId: map['sponsor_id'] as String?,
      title: map['title'] as String,
      sport: map['sport'] as String,
      description: map['description'] as String?,
      lat: lat,
      lng: lng,
      venueName: (map['venue_name'] as String?) ?? '',
      venueAddress: map['venue_address'] as String?,
      scheduledAt: DateTime.parse(map['scheduled_at'] as String),
      durationMin: (map['duration_min'] as num?)?.toInt() ?? 90,
      maxCapacity: (map['max_capacity'] as num?)?.toInt() ?? 20,
      spotsRx: (map['spots_rx'] as num?)?.toInt() ?? 0,
      spotsScaled: (map['spots_scaled'] as num?)?.toInt() ?? 0,
      spotsBeginner: (map['spots_beginner'] as num?)?.toInt() ?? 0,
      priceMxn: (map['price_mxn'] as num?)?.toDouble() ?? 0,
      wodDescription: wod,
      isSponsored: map['is_sponsored'] as bool? ?? true,
      status: map['status'] as String? ?? 'open',
      distanceM: (map['distance_m'] as num?)?.toDouble(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'sponsor_id': sponsorId,
        'title': title,
        'sport': sport,
        'description': description,
        'lat': lat,
        'lng': lng,
        'venue_name': venueName,
        'venue_address': venueAddress,
        'scheduled_at': scheduledAt.toIso8601String(),
        'duration_min': durationMin,
        'max_capacity': maxCapacity,
        'spots_rx': spotsRx,
        'spots_scaled': spotsScaled,
        'spots_beginner': spotsBeginner,
        'price_mxn': priceMxn,
        'wod_description': wodDescription,
        'is_sponsored': isSponsored,
        'status': status,
      };
}
