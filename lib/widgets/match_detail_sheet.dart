import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/actions.dart';
import '../utils/formatters.dart';
import 'match_timeline.dart';
import 'rating_bar.dart';
import 'skill_chip.dart';
import 'status_badge.dart';
import 'swap_candidate_card.dart';
import 'user_avatar.dart';
import '../l10n/app_text.dart';

class MatchDetailSheet extends StatelessWidget {
  final String requestId;

  const MatchDetailSheet({
    super.key,
    required this.requestId,
  });

  static Future<void> show(BuildContext context, String requestId) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => MatchDetailSheet(requestId: requestId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser!;
    final request = state.requestById(requestId);
    if (request == null) {
      return const SizedBox.shrink();
    }
    final partner = state.userById(request.otherUserId(me.id));
    final status = state.statusOf(request);
    final session = request.latestSession;
    final myReview = request.reviewBy(me.id);
    final partnerReview = request.reviewBy(partner.id);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Row(
              children: [
                UserAvatar(user: partner, size: 52, showRing: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        partner.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(status, compact: true),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              status.description,
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 16),
            if (session != null) ...[
              _Surface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tr('Buổi học'),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const Spacer(),
                        if (session.rescheduleCount > 0)
                          SoftBadge(
                            label: trArgs(
                              'Đổi lịch {count} lần',
                              {'count': '${session.rescheduleCount}'},
                            ),
                            color: AppColors.accent,
                            compact: true,
                            icon: Icons.update_rounded,
                          ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    SessionInfoLine(
                      startTime: session.startTime,
                      durationMinutes: session.durationMinutes,
                      location: session.location,
                      modeLabel: session.mode.label,
                    ),
                    if (session.note.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '“${session.note}”',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.45,
                          fontStyle: FontStyle.italic,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        SoftBadge(
                          label: session.mode.label,
                          color: session.mode == SessionMode.online
                              ? AppColors.info
                              : AppColors.secondary,
                          icon: session.mode == SessionMode.online
                              ? Icons.videocam_rounded
                              : Icons.place_rounded,
                          compact: true,
                        ),
                        SoftBadge(
                          label: session.status.label,
                          color: session.status == SessionStatus.completed
                              ? AppColors.success
                              : AppColors.primary,
                          compact: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            _Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tr('Lời nhắn'),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request.message,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.route_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6),
                      Text(
                        tr('Vòng đời ghép đôi'),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  MatchTimeline(
                    request: request,
                    status: status,
                    now: state.now,
                    currentUserId: me.id,
                  ),
                ],
              ),
            ),
            if (request.cancelReason != null &&
                request.cancelReason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.danger,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        trArgs(
                          'Lý do huỷ: {reason}',
                          {'reason': '${request.cancelReason}'},
                        ),
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.45,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (status == SwapStatus.completed) ...[
              const SizedBox(height: 12),
              _Surface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.reviews_rounded,
                          size: 16,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: 6),
                        Text(
                          tr('Đánh giá hai chiều'),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _ReviewTile(
                      title: trArgs(
                        'Bạn đánh giá {name}',
                        {'name': partner.name},
                      ),
                      review: myReview,
                      emptyText: tr('Bạn chưa đánh giá buổi học này'),
                      now: state.now,
                    ),
                    const SizedBox(height: 10),
                    _ReviewTile(
                      title: trArgs(
                        '{name} đánh giá bạn',
                        {'name': partner.name},
                      ),
                      review: partnerReview,
                      emptyText: tr('Đối phương chưa đánh giá'),
                      now: state.now,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            ..._actions(context, state, request, status),
          ],
        );
      },
    );
  }

  List<Widget> _actions(
    BuildContext context,
    AppState state,
    SwapRequest request,
    SwapStatus status,
  ) {
    final me = state.currentUser!;
    final isIncoming = request.receiverId == me.id;

    switch (status) {
      case SwapStatus.pending:
        if (isIncoming) {
          return [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => rejectFlow(context, state, request),
                    child: Text(tr('Từ chối')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () => acceptFlow(context, state, request),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: Text(tr('Chấp nhận ghép đôi')),
                  ),
                ),
              ],
            ),
          ];
        }
        return [
          FilledButton.tonalIcon(
            onPressed: () => partnerAcceptedFlow(context, state, request),
            icon: const Icon(Icons.science_outlined, size: 17),
            label: Text(tr('Demo: đối phương đồng ý')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => cancelFlow(context, state, request),
            child: Text(tr('Thu hồi lời mời')),
          ),
        ];
      case SwapStatus.accepted:
        return [
          FilledButton.icon(
            onPressed: () => openSchedule(context, request),
            icon: const Icon(Icons.event_available_rounded, size: 18),
            label: Text(tr('Chọn lịch học')),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => cancelFlow(context, state, request),
            child: Text(tr('Huỷ kết nối')),
          ),
        ];
      case SwapStatus.scheduled:
        return [
          FilledButton.icon(
            onPressed: () => openSchedule(context, request),
            icon: const Icon(Icons.update_rounded, size: 18),
            label: Text(tr('Đổi lịch học')),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => cancelFlow(context, state, request),
                  child: Text(tr('Huỷ buổi')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => completeFlow(context, state, request),
                  icon: const Icon(Icons.science_outlined, size: 15),
                  label: Text(tr('Kết thúc (demo)')),
                ),
              ),
            ],
          ),
        ];
      case SwapStatus.completed:
        if (request.needsMyReview(me.id)) {
          return [
            FilledButton.icon(
              onPressed: () => openReview(context, request),
              icon: const Icon(Icons.star_rounded, size: 19),
              label: Text(tr('Đánh giá ngay')),
            ),
          ];
        }
        return [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr('Đóng')),
          ),
        ];
      case SwapStatus.rejected:
      case SwapStatus.expired:
      case SwapStatus.cancelled:
        return [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr('Đóng')),
          ),
        ];
    }
  }
}

class _Surface extends StatelessWidget {
  final Widget child;

  const _Surface({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String title;
  final Review? review;
  final String emptyText;
  final DateTime now;

  const _ReviewTile({
    required this.title,
    required this.review,
    required this.emptyText,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    if (review == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          emptyText,
          style: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: AppColors.muted,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              RatingStars(
                rating: review!.rating.toDouble(),
                size: 12,
                showValue: false,
              ),
            ],
          ),
          if (review!.comment.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              review!.comment,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: AppColors.muted,
              ),
            ),
          ],
          if (review!.tags.isNotEmpty) ...[
            const SizedBox(height: 7),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: review!.tags
                  .map(
                    (tag) => SkillChip.fromString(
                      tr(tag),
                      tone: SkillTone.highlight,
                      compact: true,
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 5),
          Text(
            timeAgo(review!.createdAt, now),
            style: TextStyle(
              fontSize: 9.5,
              color: AppColors.muted.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
