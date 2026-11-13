import 'package:flutter/material.dart';

import '../models/skill.dart';
import '../models/user.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/skill_chip.dart';
import '../widgets/skill_picker_sheet.dart';
import '../widgets/user_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _majorController;
  late final TextEditingController _bioController;
  late String _year;
  late Set<String> _teaching;
  late Set<String> _learning;
  late final User _original;

  @override
  void initState() {
    super.initState();
    _original = AppScope.read(context).currentUser!;
    _nameController = TextEditingController(text: _original.name);
    _majorController = TextEditingController(text: _original.major);
    _bioController = TextEditingController(text: _original.bio);
    _year = _original.year.isEmpty ? 'K18' : _original.year;
    _teaching = _original.teachingSkills.map((s) => s.name).toSet();
    _learning = _original.learningSkills.map((s) => s.name).toSet();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _editSkills({required bool teaching}) async {
    final result = await SkillPickerSheet.show(
      context,
      title: teaching ? 'Kỹ năng có thể dạy' : 'Kỹ năng muốn học',
      subtitle: teaching
          ? 'Chọn những gì bạn tự tin chia sẻ'
          : 'Chọn những gì bạn muốn trao đổi',
      initial: teaching ? _teaching : _learning,
      tone: teaching ? AppColors.secondary : AppColors.primary,
    );
    if (result == null) return;
    setState(() {
      if (teaching) {
        _teaching = result;
      } else {
        _learning = result;
      }
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    final major = _majorController.text.trim();

    if (name.isEmpty) {
      _showError('Họ và tên không được để trống.');
      return;
    }
    if (major.isEmpty) {
      _showError('Vui lòng nhập ngành học.');
      return;
    }
    if (_teaching.isEmpty) {
      _showError('Hãy chọn ít nhất một kỹ năng có thể dạy.');
      return;
    }
    if (_learning.isEmpty) {
      _showError('Hãy chọn ít nhất một kỹ năng muốn học.');
      return;
    }

    final updated = _original.copyWith(
      name: name,
      major: major,
      year: _year,
      bio: _bioController.text.trim(),
      teachingSkills: _teaching.map(Skill.fromName).toList(),
      learningSkills: _learning.map(Skill.fromName).toList(),
    );

    AppScope.read(context).updateCurrentUser(updated);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật hồ sơ của bạn.')),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Lưu'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          Center(
            child: Column(
              children: [
                UserAvatar(
                  user: _original,
                  size: 82,
                  showRing: true,
                  showOnline: true,
                ),
                TextButton.icon(
                  onPressed: () => _showError(
                    'Ảnh đại diện được tạo tự động từ tên trong bản demo.',
                  ),
                  icon: const Icon(Icons.face_rounded, size: 15),
                  label: const Text(
                    'Ảnh đại diện tự động',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _Section(
            title: 'Thông tin cá nhân',
            icon: Icons.person_outline_rounded,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _majorController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Ngành học',
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
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15,
                          ),
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
                const SizedBox(height: 12),
                TextField(
                  controller: _bioController,
                  maxLines: 4,
                  maxLength: 240,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Giới thiệu bản thân',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SkillSection(
            title: 'Kỹ năng có thể dạy',
            icon: Icons.school_rounded,
            tone: AppColors.secondary,
            skills: _teaching,
            onEdit: () => _editSkills(teaching: true),
            onRemove: (name) => setState(() => _teaching.remove(name)),
          ),
          const SizedBox(height: 12),
          _SkillSection(
            title: 'Kỹ năng muốn học',
            icon: Icons.menu_book_rounded,
            tone: AppColors.primary,
            skills: _learning,
            onEdit: () => _editSkills(teaching: false),
            onRemove: (name) => setState(() => _learning.remove(name)),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_rounded, size: 18),
            label: const Text('Lưu thay đổi'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: AppColors.primary),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SkillSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color tone;
  final Set<String> skills;
  final VoidCallback onEdit;
  final ValueChanged<String> onRemove;

  const _SkillSection({
    required this.title,
    required this.icon,
    required this.tone,
    required this.skills,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: tone),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  foregroundColor: tone,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: const Size(0, 32),
                ),
                icon: const Icon(Icons.add_rounded, size: 15),
                label: const Text(
                  'Chọn',
                  style: TextStyle(fontSize: 11.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (skills.isEmpty)
            Text(
              'Chưa có kỹ năng nào. Bấm “Chọn” để thêm.',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: AppColors.muted.withValues(alpha: 0.9),
              ),
            )
          else
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: skills.map((name) {
                return SkillChip(
                  skill: Skill.fromName(name),
                  tone: tone == AppColors.secondary
                      ? SkillTone.teaching
                      : SkillTone.learning,
                  onDeleted: () => onRemove(name),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
