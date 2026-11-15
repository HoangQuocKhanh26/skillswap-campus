import 'package:flutter/material.dart';

import '../services/matching_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'match_score_ring.dart';
import 'rating_bar.dart';
import 'skill_chip.dart';
import 'status_badge.dart';
import 'user_avatar.dart';
import '../l10n/app_text.dart';

/// Card hồ sơ dùng trong bộ bài vuốt ở màn hình Khám phá.
class SwapCandidateCard extends StatelessWidget {
  final MatchingResult result;
  final VoidCallback? onTap;

  const SwapCandidateCard({
    super.key,
    required this.result,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = result.user;
    final teaching = user.teachingSkills;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAvatar(
                    user: user,
                    size: 68,
                    heroTag: 'avatar-${user.id}',
                    showOnline: true,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (user.rating >= 4.9)
                              Icon(
                                Icons.verified_rounded,
                                size: 17,
                                color: AppColors.info,
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 5),
                        RatingStars(
                          rating: user.rating,
                          reviewCount: user.reviewCount,
                          size: 13.5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  MatchScoreRing(
                    percent: result.percent,
                    size: 60,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  SoftBadge(
                    label: result.isMutual
                        ? tr('Trao đổi 2 chiều')
                        : tr('Gợi ý cho bạn'),
                    color: result.isMutual
                        ? AppColors.success
                        : AppColors.slate,
                    icon: result.isMutual
                        ? Icons.sync_alt_rounded
                        : Icons.auto_awesome_rounded,
                    compact: true,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                user.bio,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 12),
              _ExchangeBox(
                youTeach: result.youTeachThem,
                theyTeach: result.theyTeachYou,
              ),
              const SizedBox(height: 12),
              Text(
                tr('Có thể dạy'),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.muted.withValues(alpha: 0.95),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 7),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: teaching
                    .take(4)
                    .map((skill) => SkillChip(
                          skill: skill,
                          tone: SkillTone.teaching,
                          compact: true,
                        ))
                    .toList(),
              ),
              if (user.learningSkills.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 14,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      tr('Muốn học: '),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.muted,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        user.learningSkills.map((s) => s.name).join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    size: 15,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    trArgs(
                      'Phản hồi {time}',
                      {'time': user.responseTime},
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    tr('Xem hồ sơ'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExchangeBox extends StatelessWidget {
  final List<String> youTeach;
  final List<String> theyTeach;

  const _ExchangeBox({
    required this.youTeach,
    required this.theyTeach,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _Direction(
              label: tr('Bạn dạy họ'),
              skills: youTeach,
              icon: Icons.arrow_upward_rounded,
              color: AppColors.secondary,
              emptyText: tr('Chưa có kỹ năng trùng'),
            ),
          ),
          Container(
            width: 1,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: AppColors.primary.withValues(alpha: 0.14),
          ),
          Expanded(
            child: _Direction(
              label: tr('Họ dạy bạn'),
              skills: theyTeach,
              icon: Icons.arrow_downward_rounded,
              color: AppColors.primary,
              emptyText: tr('Thử kỹ năng khác'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Direction extends StatelessWidget {
  final String label;
  final List<String> skills;
  final IconData icon;
  final Color color;
  final String emptyText;

  const _Direction({
    required this.label,
    required this.skills,
    required this.icon,
    required this.color,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (skills.isEmpty)
          Text(
            emptyText,
            style: TextStyle(
              fontSize: 10.5,
              fontStyle: FontStyle.italic,
              color: AppColors.muted,
            ),
          )
        else
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: skills
                .take(2)
                .map(
                  (name) => SkillChip.fromString(
                    name,
                    tone: SkillTone.neutral,
                    compact: true,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

/// Card buổi học sắp tới, dùng chung ở lịch và chi tiết.
class SessionInfoLine extends StatelessWidget {
  final DateTime startTime;
  final int durationMinutes;
  final String location;
  final String modeLabel;

  const SessionInfoLine({
    super.key,
    required this.startTime,
    required this.durationMinutes,
    required this.location,
    required this.modeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: AppColors.muted,
            ),
            const SizedBox(width: 6),
            Text(
              '${formatDate(startTime)} · ${formatTime(startTime)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 14,
              color: AppColors.muted,
            ),
            const SizedBox(width: 6),
            Text(
              '${formatTimeRange(startTime, durationMinutes)} · '
              '${durationLabel(durationMinutes)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(
              modeLabel == tr('Trực tuyến')
                  ? Icons.videocam_rounded
                  : Icons.place_rounded,
              size: 14,
              color: AppColors.muted,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
