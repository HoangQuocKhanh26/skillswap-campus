import 'package:flutter/material.dart';

import '../models/skill.dart';
import '../models/user.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import 'home_shell.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _majorController = TextEditingController();
  final _bioController = TextEditingController();

  String _year = 'K18';
  int _step = 0;
  final Set<String> _teaching = {};
  final Set<String> _learning = {};

  static const List<String> _steps = [
    'Thông tin',
    'Kỹ năng dạy',
    'Kỹ năng học',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = _nameController.text.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _next() {
    FocusScope.of(context).unfocus();

    if (_step == 0) {
      if (_nameController.text.trim().isEmpty) {
        _showError('Vui lòng nhập họ và tên của bạn.');
        return;
      }
      if (_majorController.text.trim().isEmpty) {
        _showError('Vui lòng nhập ngành học của bạn.');
        return;
      }
    }

    if (_step == 1 && _teaching.isEmpty) {
      _showError('Chọn ít nhất một kỹ năng bạn có thể dạy.');
      return;
    }

    if (_step == 2) {
      if (_learning.isEmpty) {
        _showError('Chọn ít nhất một kỹ năng bạn muốn học.');
        return;
      }
      _complete();
      return;
    }

    setState(() => _step++);
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
    }
  }

  void _complete() {
    final user = User(
      id: 'me',
      name: _nameController.text.trim(),
      bio: _bioController.text.trim().isEmpty
          ? 'Mình mới tham gia SkillSwap Campus và đang tìm người cùng trao đổi kỹ năng.'
          : _bioController.text.trim(),
      avatarUrl: '',
      major: _majorController.text.trim(),
      year: _year,
      teachingSkills: _teaching.map(Skill.fromName).toList(),
      learningSkills: _learning.map(Skill.fromName).toList(),
      responseTime: 'trong 2 giờ',
    );

    AppScope.of(context).startSession(user);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  void _fillDemo() {
    setState(() {
      _nameController.text = 'Minh Thư';
      _majorController.text = 'Truyền thông đa phương tiện';
      _bioController.text =
          'Mình làm content và dựng video cho CLB. Muốn học Flutter để tự làm app quản lý lịch học và portfolio.';
      _year = 'K19';
      _teaching
        ..clear()
        ..addAll(['Video Editing', 'Marketing', 'Photoshop']);
      _learning
        ..clear()
        ..addAll(['Flutter', 'UI/UX', 'Public Speaking']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã điền hồ sơ mẫu, bạn có thể chỉnh lại.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo hồ sơ sinh viên'),
        actions: [
          TextButton(
            onPressed: _fillDemo,
            child: const Text('Dùng mẫu'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _StepProgress(currentStep: _step, labels: _steps),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: SingleChildScrollView(
                key: ValueKey(_step),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: switch (_step) {
                  0 => _buildInfoStep(),
                  1 => _buildSkillStep(
                      title: 'Bạn có thể dạy gì?',
                      subtitle:
                          'Chọn những kỹ năng bạn tự tin chia sẻ cho bạn học. '
                          'Không cần là chuyên gia, chỉ cần hơn người cần học một chút!',
                      selected: _teaching,
                      tone: AppColors.secondary,
                      icon: Icons.school_rounded,
                    ),
                  _ => _buildSkillStep(
                      title: 'Bạn muốn học gì?',
                      subtitle:
                          'Chọn kỹ năng bạn muốn trao đổi. App sẽ ưu tiên gợi ý '
                          'người có thể dạy đúng những kỹ năng này.',
                      selected: _learning,
                      tone: AppColors.primary,
                      icon: Icons.menu_book_rounded,
                    ),
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              if (_step > 0) ...[
                OutlinedButton(
                  onPressed: _back,
                  child: const Icon(Icons.arrow_back_rounded, size: 18),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _step == 2 ? 'Hoàn tất hồ sơ' : 'Tiếp tục',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF0D9488)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: () => _showError(
              'Ảnh đại diện được tạo tự động từ tên của bạn trong bản demo.',
            ),
            icon: const Icon(Icons.face_rounded, size: 16),
            label: const Text('Ảnh đại diện tự động'),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Họ và tên *',
            hintText: 'Ví dụ: Ngọc Anh',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _majorController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Ngành học *',
                  hintText: 'Kỹ thuật phần mềm',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                initialValue: _year,
                decoration: const InputDecoration(
                  labelText: 'Khoá',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                ),
                items: const ['K15', 'K16', 'K17', 'K18', 'K19', 'K20']
                    .map(
                      (year) => DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _year = value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 240,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Giới thiệu bản thân',
            hintText:
                'Bạn đang học gì, có kinh nghiệm gì và muốn trao đổi điều gì?',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.accentSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 18,
                color: Color(0xFFB45309),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Mẹo: hồ sơ càng cụ thể càng dễ được ghép cặp. '
                  'Ví dụ “mình biết Flutter, muốn học Java”.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillStep({
    required String title,
    required String subtitle,
    required Set<String> selected,
    required Color tone,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: tone, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    'Đã chọn ${selected.length} kỹ năng',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: tone,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12.5,
            height: 1.5,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 18),
        ...SkillCatalog.categoryOrder.map((category) {
          final skills = SkillCatalog.byCategory(category);
          if (skills.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.border,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: skills.map((skill) {
                    final isSelected = selected.contains(skill.name);
                    return FilterChip(
                      selected: isSelected,
                      showCheckmark: false,
                      avatar: Text(
                        skill.emoji,
                        style: const TextStyle(fontSize: 13),
                      ),
                      label: Text(skill.name),
                      selectedColor: tone,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? tone
                            : AppColors.border,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.ink,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 12.5,
                      ),
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            selected.add(skill.name);
                          } else {
                            selected.remove(skill.name);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }),
        if (_step == 2)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primarySoft.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bạn có thể chỉnh sửa kỹ năng bất cứ lúc nào trong Hồ sơ.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.45,
                      color: AppColors.primary.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const _StepProgress({
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 16),
      child: Column(
        children: [
          Row(
            children: List.generate(labels.length, (index) {
              final active = index <= currentStep;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == labels.length - 1 ? 0 : 6,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 5,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(labels.length, (index) {
              final active = index <= currentStep;
              return Expanded(
                child: Text(
                  '${index + 1}. ${labels[index]}',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight:
                        active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? AppColors.primary : AppColors.muted,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
