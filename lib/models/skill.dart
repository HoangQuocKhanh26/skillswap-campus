/// Một kỹ năng kèm nhóm và biểu tượng để hiển thị đẹp hơn trên chip.
class Skill {
  final String id;
  final String name;
  final String category;
  final String emoji;

  const Skill({
    required this.id,
    required this.name,
    this.category = 'Khác',
    this.emoji = '✨',
  });

  /// Tạo skill từ tên, tự tra cứu emoji + nhóm trong [SkillCatalog].
  factory Skill.fromName(String name) {
    final trimmed = name.trim();
    return Skill(
      id: trimmed,
      name: trimmed,
      category: SkillCatalog.categoryOf(trimmed),
      emoji: SkillCatalog.emojiOf(trimmed),
    );
  }

  String get normalizedName => name.trim().toLowerCase();

  @override
  bool operator ==(Object other) =>
      other is Skill && other.normalizedName == normalizedName;

  @override
  int get hashCode => normalizedName.hashCode;

  @override
  String toString() => name;
}

/// Danh mục kỹ năng mẫu dùng cho toàn bộ app.
class SkillCatalog {
  SkillCatalog._();

  static const Map<String, String> _emojis = {
    'Flutter': '🐦',
    'Dart': '🎯',
    'Java': '☕',
    'Python': '🐍',
    'C++': '🔧',
    'JavaScript': '⚡',
    'React': '⚛️',
    'Node.js': '🟩',
    'Firebase': '🔥',
    'Android': '🤖',
    'Git': '🌿',
    'SQL': '🗄️',
    'HTML': '🌐',
    'CSS': '🎨',
    'Figma': '🧩',
    'UI/UX': '🖌️',
    'Photoshop': '🖼️',
    'Illustrator': '✒️',
    'Thiết kế đồ hoạ': '🎭',
    'Video Editing': '🎬',
    'Tiếng Anh': '🇬🇧',
    'Tiếng Nhật': '🗾',
    'Tiếng Hàn': '🇰🇷',
    'Public Speaking': '🎤',
    'Marketing': '📣',
    'Excel': '📈',
    'Data Analysis': '📊',
    'Machine Learning': '🤖',
    'Guitar': '🎸',
    'Chụp ảnh': '📷',
    'Vẽ tay': '✏️',
    'Nấu ăn': '🍳',
    'Yoga': '🧘',
  };

  static const Map<String, String> _categories = {
    'Flutter': 'Lập trình',
    'Dart': 'Lập trình',
    'Java': 'Lập trình',
    'Python': 'Lập trình',
    'C++': 'Lập trình',
    'JavaScript': 'Lập trình',
    'React': 'Lập trình',
    'Node.js': 'Lập trình',
    'Firebase': 'Lập trình',
    'Android': 'Lập trình',
    'Git': 'Lập trình',
    'SQL': 'Dữ liệu',
    'Data Analysis': 'Dữ liệu',
    'Machine Learning': 'Dữ liệu',
    'Excel': 'Dữ liệu',
    'HTML': 'Lập trình',
    'CSS': 'Lập trình',
    'Figma': 'Thiết kế',
    'UI/UX': 'Thiết kế',
    'Photoshop': 'Thiết kế',
    'Illustrator': 'Thiết kế',
    'Thiết kế đồ hoạ': 'Thiết kế',
    'Video Editing': 'Nghệ thuật',
    'Chụp ảnh': 'Nghệ thuật',
    'Vẽ tay': 'Nghệ thuật',
    'Guitar': 'Nghệ thuật',
    'Tiếng Anh': 'Ngoại ngữ',
    'Tiếng Nhật': 'Ngoại ngữ',
    'Tiếng Hàn': 'Ngoại ngữ',
    'Public Speaking': 'Kỹ năng mềm',
    'Marketing': 'Kinh doanh',
    'Nấu ăn': 'Đời sống',
    'Yoga': 'Đời sống',
  };

  static const List<String> categoryOrder = [
    'Lập trình',
    'Dữ liệu',
    'Thiết kế',
    'Ngoại ngữ',
    'Kỹ năng mềm',
    'Kinh doanh',
    'Nghệ thuật',
    'Đời sống',
    'Khác',
  ];

  static List<String> get allNames => _emojis.keys.toList(growable: false);

  static String emojiOf(String name) => _emojis[name.trim()] ?? '✨';

  static String categoryOf(String name) =>
      _categories[name.trim()] ?? 'Khác';

  static List<Skill> byCategory(String category) {
    return _emojis.entries
        .where((entry) => categoryOf(entry.key) == category)
        .map((entry) => Skill(
              id: entry.key,
              name: entry.key,
              category: category,
              emoji: entry.value,
            ))
        .toList();
  }

  static List<Skill> get all {
    return _emojis.entries
        .map((entry) => Skill(
              id: entry.key,
              name: entry.key,
              category: categoryOf(entry.key),
              emoji: entry.value,
            ))
        .toList(growable: false);
  }
}
