import 'dart:math' as math;

import '../models/user.dart';
import '../l10n/app_text.dart';

/// Kết quả ghép cặp kèm giải thích vì sao hai người phù hợp.
class MatchingResult {
  final User user;

  /// Số kỹ năng trùng theo cả hai chiều (giữ nguyên API cũ để test).
  final int score;

  /// Những kỹ năng đối phương dạy được cho mình.
  final List<String> theyTeachYou;

  /// Những kỹ năng mình dạy được cho đối phương.
  final List<String> youTeachThem;

  const MatchingResult({
    required this.user,
    required this.score,
    this.theyTeachYou = const [],
    this.youTeachThem = const [],
  });

  bool get isMutual => theyTeachYou.isNotEmpty && youTeachThem.isNotEmpty;

  /// Điểm phù hợp hiển thị trên UI (0 – 100).
  int get percent {
    var value = 0;
    value += math.min(theyTeachYou.length, 3) * 22;
    value += math.min(youTeachThem.length, 3) * 12;
    if (isMutual) value += 8;
    return math.min(100, value);
  }

  String get label {
    if (percent >= 85) return tr('Rất phù hợp');
    if (percent >= 60) return tr('Phù hợp');
    if (percent >= 35) return tr('Có tiềm năng');
    return tr('Gợi ý mở rộng');
  }

  String get reason {
    if (isMutual && theyTeachYou.isNotEmpty) {
      return trArgs(
        'Trao đổi hai chiều: {a} ↔ {b}',
        {
          'a': theyTeachYou.first,
          'b': youTeachThem.first,
        },
      );
    }
    if (theyTeachYou.isNotEmpty) {
      return trArgs(
        '{name} có thể dạy bạn {skill}',
        {
          'name': user.name.split(' ').last,
          'skill': theyTeachYou.first,
        },
      );
    }
    if (youTeachThem.isNotEmpty) {
      return trArgs(
        '{name} muốn học {skill} từ bạn',
        {
          'name': user.name.split(' ').last,
          'skill': youTeachThem.first,
        },
      );
    }
    return tr('Cùng quan tâm đến kỹ năng trong lớp');
  }
}

class MatchingService {
  const MatchingService();

  Set<String> getSkillNames(List<dynamic> skills) {
    return skills
        .map((skill) => skill.name.toString().trim().toLowerCase())
        .where((name) => name.isNotEmpty)
        .toSet();
  }

  /// Tính điểm phù hợp hai chiều giữa hai người.
  int calculateScore({
    required User currentUser,
    required User candidate,
  }) {
    final myTeaching = getSkillNames(currentUser.teachingSkills);
    final myLearning = getSkillNames(currentUser.learningSkills);
    final otherTeaching = getSkillNames(candidate.teachingSkills);
    final otherLearning = getSkillNames(candidate.learningSkills);

    final teachMatch = myTeaching.intersection(otherLearning).length;
    final learnMatch = myLearning.intersection(otherTeaching).length;

    return teachMatch + learnMatch;
  }

  List<String> _matchedNames({
    required List<dynamic> source,
    required Set<String> target,
  }) {
    final seen = <String>{};
    final names = <String>[];
    for (final skill in source) {
      final name = skill.name.toString().trim();
      final normalized = name.toLowerCase();
      if (target.contains(normalized) && seen.add(normalized)) {
        names.add(name);
      }
    }
    return names;
  }

  MatchingResult evaluate({
    required User currentUser,
    required User candidate,
  }) {
    final myTeaching = getSkillNames(currentUser.teachingSkills);
    final myLearning = getSkillNames(currentUser.learningSkills);
    final otherTeaching = getSkillNames(candidate.teachingSkills);
    final otherLearning = getSkillNames(candidate.learningSkills);

    final theyTeachYou = _matchedNames(
      source: candidate.teachingSkills,
      target: myLearning,
    );
    final youTeachThem = _matchedNames(
      source: currentUser.teachingSkills,
      target: otherLearning,
    );

    return MatchingResult(
      user: candidate,
      score: myTeaching.intersection(otherLearning).length +
          myLearning.intersection(otherTeaching).length,
      theyTeachYou: theyTeachYou,
      youTeachThem: youTeachThem,
    );
  }

  /// Tìm và sắp xếp người phù hợp (chỉ giữ người có ít nhất 1 kỹ năng trùng).
  List<MatchingResult> getRecommendations({
    required User currentUser,
    required List<User> candidates,
  }) {
    final results = <MatchingResult>[];

    for (final candidate in candidates) {
      if (candidate.id == currentUser.id) continue;

      final result = evaluate(
        currentUser: currentUser,
        candidate: candidate,
      );

      if (result.score > 0) {
        results.add(result);
      }
    }

    results.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return b.percent.compareTo(a.percent);
    });

    return results;
  }
}
