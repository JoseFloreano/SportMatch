class RatingModel {
  final String id;
  final String? sessionId;
  final String? eventId;
  final String raterId;
  final String ratedId;
  final int punctuality; // 1-5
  final int levelAccuracy; // 1-5
  final int respect; // 1-5
  final double overall; // calculado en DB (GENERATED) o derivado
  final String? comment;
  final DateTime createdAt;

  const RatingModel({
    required this.id,
    this.sessionId,
    this.eventId,
    required this.raterId,
    required this.ratedId,
    required this.punctuality,
    required this.levelAccuracy,
    required this.respect,
    required this.overall,
    this.comment,
    required this.createdAt,
  });

  /// Promedio local (la DB lo calcula con una columna GENERATED).
  static double computeOverall(int punctuality, int levelAccuracy, int respect) {
    return double.parse(
      ((punctuality + levelAccuracy + respect) / 3.0).toStringAsFixed(2),
    );
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) => RatingModel(
        id: map['id'] as String,
        sessionId: map['session_id'] as String?,
        eventId: map['event_id'] as String?,
        raterId: map['rater_id'] as String,
        ratedId: map['rated_id'] as String,
        punctuality: (map['punctuality'] as num).toInt(),
        levelAccuracy: (map['level_accuracy'] as num).toInt(),
        respect: (map['respect'] as num).toInt(),
        overall: (map['overall'] as num?)?.toDouble() ??
            computeOverall(
              (map['punctuality'] as num).toInt(),
              (map['level_accuracy'] as num).toInt(),
              (map['respect'] as num).toInt(),
            ),
        comment: map['comment'] as String?,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : DateTime.now(),
      );

  /// No incluye `overall` (la DB lo genera) ni `id`/`created_at`.
  Map<String, dynamic> toMap() => {
        'session_id': sessionId,
        'event_id': eventId,
        'rater_id': raterId,
        'rated_id': ratedId,
        'punctuality': punctuality,
        'level_accuracy': levelAccuracy,
        'respect': respect,
        'comment': comment,
      };
}
