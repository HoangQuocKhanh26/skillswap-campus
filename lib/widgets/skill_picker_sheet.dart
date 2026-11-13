import 'package:flutter/material.dart';

import '../models/skill.dart';
import '../theme/app_theme.dart';

/// Bottom sheet chọn nhiều kỹ năng, dùng lại cho onboarding và chỉnh sửa hồ sơ.
class SkillPickerSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final Set<String> initial;
  final Color tone;

  const SkillPickerSheet({
    super.key,
    required this.title,
    required this.initial,
    this.subtitle = 'Chọn một hoặc nhiều kỹ năng',
    this.tone = AppColors.primary,
  });

  static Future<Set<String>?> show(
    BuildContext context, {
    required String title,
    required Set<String> initial,
    String subtitle = 'Chọn một hoặc nhiều kỹ năng',
    Color tone = AppColors.primary,
  }) {
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => SkillPickerSheet(
        title: title,
        initial: initial,
        subtitle: subtitle,
        tone: tone,
      ),
    );
  }

  @override
  State<SkillPickerSheet> createState() => _SkillPickerSheetState();
}

class _SkillPickerSheetState extends State<SkillPickerSheet> {
  late final Set<String> _selected = {...widget.initial};
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.86;
    final query = _search.trim().toLowerCase();

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: widget.tone.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_selected.length} đã chọn',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: widget.tone,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _search = value),
              decoration: const InputDecoration(
                hintText: 'Tìm kỹ năng...',
                prefixIcon: Icon(Icons.search_rounded, size: 19),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                children: SkillCatalog.categoryOrder.map((category) {
                  final skills = SkillCatalog.byCategory(category)
                      .where((skill) =>
                          query.isEmpty ||
                          skill.name.toLowerCase().contains(query))
                      .toList();
                  if (skills.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: skills.map((skill) {
                            final selected = _selected.contains(skill.name);
                            return FilterChip(
                              selected: selected,
                              showCheckmark: false,
                              avatar: Text(
                                skill.emoji,
                                style: const TextStyle(fontSize: 12),
                              ),
                              label: Text(skill.name),
                              selectedColor: widget.tone,
                              labelStyle: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color:
                                    selected ? Colors.white : AppColors.ink,
                              ),
                              onSelected: (value) {
                                setState(() {
                                  if (value) {
                                    _selected.add(skill.name);
                                  } else {
                                    _selected.remove(skill.name);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.tone,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pop(Set<String>.from(_selected)),
                  child: Text('Lưu ${_selected.length} kỹ năng'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
