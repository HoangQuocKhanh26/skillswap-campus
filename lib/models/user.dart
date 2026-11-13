import 'skill.dart';

/// Hồ sơ sinh viên tham gia SkillSwap Campus.
class User {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;

  final List<Skill> teachingSkills;
  final List<Skill> learningSkills;

  final String major;
  final String year;
  final String campus;

  /// Điểm đánh giá trung bình (0 nếu chưa có đánh giá).
  final double rating;
  final int reviewCount;

  /// Thời gian phản hồi trung bình, ví dụ "trong 2 giờ".
  final String responseTime;

  const User({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.teachingSkills,
    required this.learningSkills,
    this.major = '',
    this.year = '',
    this.campus = 'Campus Hà Nội',
    this.rating = 0,
    this.reviewCount = 0,
    this.responseTime = 'trong 2 giờ',
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String get subtitle {
    final bits = [major, year].where((e) => e.trim().isNotEmpty).toList();
    return bits.isEmpty ? 'Sinh viên SkillSwap Campus' : bits.join(' · ');
  }

  User copyWith({
    String? name,
    String? bio,
    String? avatarUrl,
    List<Skill>? teachingSkills,
    List<Skill>? learningSkills,
    String? major,
    String? year,
    String? campus,
    double? rating,
    int? reviewCount,
    String? responseTime,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      teachingSkills: teachingSkills ?? this.teachingSkills,
      learningSkills: learningSkills ?? this.learningSkills,
      major: major ?? this.major,
      year: year ?? this.year,
      campus: campus ?? this.campus,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      responseTime: responseTime ?? this.responseTime,
    );
  }
}
