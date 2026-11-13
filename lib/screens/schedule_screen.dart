import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/actions.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/match_detail_sheet.dart';
import '../widgets/rating_bar.dart';
import '../widgets/skill_chip.dart';
import '../widgets/status_badge.dart';
import '../widgets/user_avatar.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final upcoming = state.upcomingSessions;
    final completed = state.completedSessions;
    final needsReview = state.needsReviewCount;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch hẹn'),
          actions: [
            if (needsReview > 0)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: SoftBadge(
                    label: '$needsReview chờ đánh giá',
                    color: AppColors.accent,
                    icon: Icons.star_rounded,
                  ),
                ),
              ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text:
                    'Sắp tới${upcoming.isEmpty ? '' : ' (${upcoming.length})'}',
              ),
              Tab(
                text:
                    'Đã xong${completed.isEmpty ? '' : ' (${completed.length})'}',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _UpcomingTab(entries: upcoming),
            _CompletedTab(entries: completed),
          ],
        ),
      ),
    );
  }
}

class _UpcomingTab extends StatelessWidget {
  final List<SessionEntry> entries;

  const _UpcomingTab({required this.entries});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (entries.isEmpty) {
      return const EmptyState(
        icon: Icons.event_note_rounded,
        title: 'Chưa có buổi học nào',
        message:
            'Khi lời mời được chấp nhận, bạn có thể chọn thời gian, địa điểm '
            'và buổi học sẽ xuất hiện trong lịch.',
        color: AppColors.primary,
      );
    }

    final children = <Widget>[];
    String? lastDay;
    for (final entry in entries) {
      final day = friendlyDay(entry.session.startTime, state.now);
      if (day != lastDay) {
        lastDay = day;
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 8, left: 2),
            child: Row(
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  formatDate(entry.session.startTime),
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(child: Divider()),
              ],
            ),
          ),
        );
      }
      children.add(_UpcomingCard(entry: entry));
      children.add(const SizedBox(height: 10));
    }

    return RefreshIndicator(
      onRefresh: () async =>
          AppScope.read(context).expireOverdueRequests(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          _SummaryBanner(count: entries.length),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final int count;

  const _SummaryBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn có $count buổi trao đổi sắp tới',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Đổi lịch hoặc huỷ trước ít nhất 2 giờ để giữ điểm uy tín nhé.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final SessionEntry entry;

  const _UpcomingCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final session = entry.session;
    final partner = entry.partner;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => MatchDetailSheet.show(context, entry.request.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${session.startTime.day}',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            height: 1,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tháng ${session.startTime.month}',
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                partner.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            RatingStars(
                              rating: partner.rating,
                              size: 10.5,
                              showValue: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          formatTimeRange(
                            session.startTime,
                            session.durationMinutes,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              session.mode == SessionMode.online
                                  ? Icons.videocam_rounded
                                  : Icons.place_rounded,
                              size: 12,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                session.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SoftBadge(
                        label: timeLeft(session.startTime, state.now),
                        color: AppColors.accent,
                        icon: Icons.timer_outlined,
                        compact: true,
                      ),
                      if (session.rescheduleCount > 0) ...[
                        const SizedBox(height: 4),
                        SoftBadge(
                          label: 'Đã đổi ${session.rescheduleCount} lần',
                          color: AppColors.slate,
                          compact: true,
                          icon: Icons.update_rounded,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              if (session.note.isNotEmpty) ...[
                const SizedBox(height: 9),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Ghi chú: ${session.note}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      height: 1.4,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: () => cancelFlow(context, state, entry.request),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.muted,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Text(
                      'Huỷ',
                      style: TextStyle(fontSize: 11.5),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () => openSchedule(context, entry.request),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                    ),
                    icon: const Icon(Icons.update_rounded, size: 14),
                    label: const Text(
                      'Đổi lịch',
                      style: TextStyle(fontSize: 11.5),
                    ),
                  ),
                  const SizedBox(width: 7),
                  FilledButton.icon(
                    onPressed: () => completeFlow(context, state, entry.request),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 15),
                    label: const Text(
                      'Kết thúc',
                      style: TextStyle(fontSize: 11.5),
                    ),
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

class _CompletedTab extends StatelessWidget {
  final List<SessionEntry> entries;

  const _CompletedTab({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const EmptyState(
        icon: Icons.task_alt_rounded,
        title: 'Chưa có buổi học hoàn thành',
        message:
            'Sau khi buổi học kết thúc, bạn và đối phương có thể gửi đánh giá hai chiều tại đây.',
        color: AppColors.success,
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _CompletedCard(entry: entries[index]),
    );
  }
}

class _CompletedCard extends StatelessWidget {
  final SessionEntry entry;

  const _CompletedCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser!;
    final request = entry.request;
    final partner = entry.partner;
    final needsReview = request.needsMyReview(me.id);
    final myReview = request.reviewBy(me.id);
    final partnerReview = request.reviewBy(partner.id);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => MatchDetailSheet.show(context, request.id),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  UserAvatar(user: partner, size: 44),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partner.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${friendlyDay(entry.session.startTime, state.now)} · '
                          '${formatTimeRange(entry.session.startTime, entry.session.durationMinutes)}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const StatusBadge(SwapStatus.completed, compact: true),
                ],
              ),
              const SizedBox(height: 10),
              if (needsReview)
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_outline_rounded,
                        size: 19,
                        color: Color(0xFFB45309),
                      ),
                      const SizedBox(width: 7),
                      const Expanded(
                        child: Text(
                          'Buổi học đã kết thúc · Chờ bạn đánh giá',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      FilledButton(
                        onPressed: () => openReview(context, request),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 34),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          backgroundColor: AppColors.accent,
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Đánh giá'),
                      ),
                    ],
                  ),
                )
              else ...[
                _ReviewLine(
                  label: 'Bạn đánh giá',
                  rating: myReview?.rating,
                  comment: myReview?.comment,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 6),
                _ReviewLine(
                  label: '${partner.name} đánh giá bạn',
                  rating: partnerReview?.rating,
                  comment: partnerReview?.comment,
                  color: AppColors.primary,
                ),
                if ((myReview?.tags.isNotEmpty ?? false) ||
                    (partnerReview?.tags.isNotEmpty ?? false)) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      ...?myReview?.tags.map(
                        (tag) => SkillChip.fromString(
                          tag,
                          tone: SkillTone.teaching,
                          compact: true,
                        ),
                      ),
                      ...?partnerReview?.tags.map(
                        (tag) => SkillChip.fromString(
                          tag,
                          tone: SkillTone.learning,
                          compact: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
              if (needsReview && partnerReview != null) ...[
                const SizedBox(height: 10),
                _ReviewLine(
                  label: '${partner.name} đánh giá bạn',
                  rating: partnerReview.rating,
                  comment: partnerReview.comment,
                  color: AppColors.primary,
                ),
                if (partnerReview.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: partnerReview.tags
                        .map(
                          (tag) => SkillChip.fromString(
                            tag,
                            tone: SkillTone.learning,
                            compact: true,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary.withValues(alpha: 0.9),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 15,
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

class _ReviewLine extends StatelessWidget {
  final String label;
  final int? rating;
  final String? comment;
  final Color color;

  const _ReviewLine({
    required this.label,
    required this.rating,
    required this.comment,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
        if (rating == null)
          const Text(
            'Chưa đánh giá',
            style: TextStyle(
              fontSize: 10.5,
              fontStyle: FontStyle.italic,
              color: AppColors.muted,
            ),
          )
        else ...[
          RatingStars(
            rating: rating!.toDouble(),
            size: 11,
            showValue: true,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              comment ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
