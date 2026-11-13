
import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap_campus/models/skill.dart';
import 'package:skillswap_campus/models/user.dart';
import 'package:skillswap_campus/services/matching_service.dart';

// Hàm tạo dữ liệu người dùng mẫu
User taoUser({
  required String id,
  required String name,
  required List<String> day,
  required List<String> hoc,
}) {
  return User(
    id: id,
    name: name,
    bio: '',
    avatarUrl: '',
    teachingSkills: day
        .map((ten) => Skill(id: ten, name: ten))
        .toList(),
    learningSkills: hoc
        .map((ten) => Skill(id: ten, name: ten))
        .toList(),
  );
}

void main() {
  final service = MatchingService();

  final ngoc = taoUser(
    id: '1',
    name: 'Ngọc',
    day: ['Flutter', 'HTML'],
    hoc: ['Java', 'Tiếng Anh'],
  );

  final banA = taoUser(
    id: '2',
    name: 'Bạn A',
    day: ['Java', 'Tiếng Anh'],
    hoc: ['Flutter', 'HTML'],
  );

  final banB = taoUser(
    id: '3',
    name: 'Bạn B',
    day: ['Java'],
    hoc: ['Flutter'],
  );

  final banC = taoUser(
    id: '4',
    name: 'Bạn C',
    day: ['Python'],
    hoc: ['CSS'],
  );

  test('Kiểm tra điểm phù hợp hai chiều', () {
    final score = service.calculateScore(
      currentUser: ngoc,
      candidate: banA,
    );

    expect(score, 4);
  });

  test('Sắp xếp người phù hợp theo điểm giảm dần', () {
    final results = service.getRecommendations(
      currentUser: ngoc,
      candidates: [
        banB,
        ngoc,
        banA,
        banC,
      ],
    );

    expect(results.length, 2);
    expect(results[0].user.name, 'Bạn A');
    expect(results[1].user.name, 'Bạn B');
  });

  test('Kết quả ghép cặp có giải thích hai chiều', () {
    final result = service.evaluate(
      currentUser: ngoc,
      candidate: banA,
    );

    expect(result.isMutual, isTrue);
    expect(result.theyTeachYou, containsAll(['Java', 'Tiếng Anh']));
    expect(result.youTeachThem, containsAll(['Flutter', 'HTML']));
    expect(result.percent, greaterThan(0));
    expect(result.percent, lessThanOrEqualTo(100));
  });
}
