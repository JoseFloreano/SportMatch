class ProfileModel {
  final String id;
  final String displayName;
  final String phone;
  final String? avatarUrl;
  final String? bio;
  final String? neighborhood;
  final List<String> sports;
  final String? level; // "rx" | "scaled" | "beginner"
  final bool womenOnlyMode;
  final bool whatsappOptin;
  final double rating;
  final int totalSessions;
  final double attendanceRate;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    required this.displayName,
    required this.phone,
    this.avatarUrl,
    this.bio,
    this.neighborhood,
    this.sports = const [],
    this.level,
    this.womenOnlyMode = false,
    this.whatsappOptin = true,
    this.rating = 0.0,
    this.totalSessions = 0,
    this.attendanceRate = 100.0,
    required this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) => ProfileModel(
        id: map['id'] as String,
        displayName: (map['display_name'] as String?) ?? '',
        phone: (map['phone'] as String?) ?? '',
        avatarUrl: map['avatar_url'] as String?,
        bio: map['bio'] as String?,
        neighborhood: map['neighborhood'] as String?,
        sports: List<String>.from((map['sports'] as List?) ?? const []),
        level: map['level'] as String?,
        womenOnlyMode: map['women_only_mode'] as bool? ?? false,
        whatsappOptin: map['whatsapp_optin'] as bool? ?? true,
        rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
        totalSessions: (map['total_sessions'] as num?)?.toInt() ?? 0,
        attendanceRate: (map['attendance_rate'] as num?)?.toDouble() ?? 100.0,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'display_name': displayName,
        'phone': phone,
        'avatar_url': avatarUrl,
        'bio': bio,
        'neighborhood': neighborhood,
        'sports': sports,
        'level': level,
        'women_only_mode': womenOnlyMode,
        'whatsapp_optin': whatsappOptin,
      };

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  ProfileModel copyWith({
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? neighborhood,
    List<String>? sports,
    String? level,
    bool? womenOnlyMode,
    bool? whatsappOptin,
  }) =>
      ProfileModel(
        id: id,
        displayName: displayName ?? this.displayName,
        phone: phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bio: bio ?? this.bio,
        neighborhood: neighborhood ?? this.neighborhood,
        sports: sports ?? this.sports,
        level: level ?? this.level,
        womenOnlyMode: womenOnlyMode ?? this.womenOnlyMode,
        whatsappOptin: whatsappOptin ?? this.whatsappOptin,
        rating: rating,
        totalSessions: totalSessions,
        attendanceRate: attendanceRate,
        createdAt: createdAt,
      );
}
