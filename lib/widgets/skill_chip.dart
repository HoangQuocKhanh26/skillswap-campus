import 'package:flutter/material.dart';

import '../models/skill.dart';
import '../theme/app_theme.dart';

enum SkillTone { neutral, teaching, learning, highlight }

/// Chip kỹ năng có emoji, dùng thống nhất trong toàn app.
class SkillChip extends StatelessWidget {
  final Skill skill;
  final SkillTone tone;
  final bool compact;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;

  const SkillChip({
    super.key,
    required this.skill,
    this.tone = SkillTone.neutral,
    this.compact = false,
    this.selected = false,
    this.onTap,
    this.onDeleted,
  });

  factory SkillChip.fromString(
    String name, {
    SkillTone tone = SkillTone.neutral,
    bool compact = false,
  }) {
    return SkillChip(
      skill: Skill.fromName(name),
      tone: tone,
      compact: compact,
    );
  }

  (Color bg, Color fg, Color border) get _colors {
    if (selected) {
      return (AppColors.primary, Colors.white, AppColors.primary);
    }
    switch (tone) {
      case SkillTone.teaching:
        return (
          AppColors.secondarySoft,
          AppColors.secondary,
          AppColors.secondary.withValues(alpha: 0.22),
        );
      case SkillTone.learning:
        return (
          AppColors.primarySoft,
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.18),
        );
      case SkillTone.highlight:
        return (
          AppColors.accentSoft,
          const Color(0xFFB45309),
          AppColors.accent.withValues(alpha: 0.3),
        );
      case SkillTone.neutral:
        return (Colors.white, AppColors.ink, AppColors.border);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    final content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.$3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill.emoji,
            style: TextStyle(fontSize: compact ? 11 : 12.5),
          ),
          const SizedBox(width: 5),
          Text(
            skill.name,
            style: TextStyle(
              fontSize: compact ? 11.5 : 12.5,
              fontWeight: FontWeight.w700,
              color: colors.$2,
            ),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(
                Icons.close_rounded,
                size: compact ? 13 : 15,
                color: colors.$2,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: content,
      ),
    );
  }
}
