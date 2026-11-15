import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../l10n/app_text.dart';

enum _StepState { done, current, future, failed }

class _TimelineStep {
  final String title;
  final String subtitle;
  final _StepState state;
  final IconData icon;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.state,
    required this.icon,
  });
}

/// Dòng thời gian mô tả vòng đời ghép đôi, gồm cả nhánh từ chối/hết hạn/huỷ.
class MatchTimeline extends StatelessWidget {
  final SwapRequest request;
  final SwapStatus status;
  final DateTime now;
  final String currentUserId;

  const MatchTimeline({
    super.key,
    required this.request,
    required this.status,
    required this.now,
    required this.currentUserId,
  });

  List<_TimelineStep> get _steps {
    final session = request.latestSession;
    final steps = <_TimelineStep>[];

    steps.add(_TimelineStep(
      title: tr('Gửi lời mời'),
      subtitle: '${timeAgo(request.createdAt, now)} · '
          '${request.isSender(currentUserId) ? 'Bạn đã gửi' : 'Đối phương đã gửi'}',
      state: _StepState.done,
      icon: Icons.send_rounded,
    ));

    switch (status) {
      case SwapStatus.pending:
        steps.add(_TimelineStep(
          title: tr('Chờ phản hồi'),
          subtitle: trArgs(
            '{time} · hết hạn sau 48 giờ',
            {'time': timeLeft(request.expiresAt, now)},
          ),
          state: _StepState.current,
          icon: Icons.hourglass_top_rounded,
        ));
        break;
      case SwapStatus.rejected:
        steps.add(_TimelineStep(
          title: tr('Đã từ chối'),
          subtitle: request.respondedAt != null
              ? timeAgo(request.respondedAt!, now)
              : tr('Lời mời không được chấp nhận'),
          state: _StepState.failed,
          icon: Icons.close_rounded,
        ));
        break;
      case SwapStatus.expired:
        steps.add(_TimelineStep(
          title: tr('Hết hạn phản hồi'),
          subtitle: trArgs(
            'Lời mời hết hạn {time}',
            {'time': timeAgo(request.expiresAt, now)},
          ),
          state: _StepState.failed,
          icon: Icons.timer_off_rounded,
        ));
        break;
      case SwapStatus.accepted:
      case SwapStatus.scheduled:
      case SwapStatus.completed:
      case SwapStatus.cancelled:
        steps.add(_TimelineStep(
          title: tr('Chấp nhận ghép đôi'),
          subtitle: request.respondedAt != null
              ? timeAgo(request.respondedAt!, now)
              : tr('Đã chấp nhận'),
          state: _StepState.done,
          icon: Icons.handshake_rounded,
        ));
        break;
    }

    if (status == SwapStatus.cancelled) {
      steps.add(_TimelineStep(
        title: tr('Đã huỷ'),
        subtitle: request.cancelReason?.isNotEmpty == true
            ? request.cancelReason!
            : tr('Buổi trao đổi đã bị huỷ'),
        state: _StepState.failed,
        icon: Icons.block_rounded,
      ));
      return steps;
    }

    if (status == SwapStatus.rejected || status == SwapStatus.expired) {
      return steps;
    }

    if (session == null) {
      steps.add(_TimelineStep(
        title: tr('Chọn lịch học'),
        subtitle: status == SwapStatus.accepted
            ? tr('Hai bạn chưa chọn thời gian')
            : tr('Chưa đặt lịch'),
        state: status == SwapStatus.accepted
            ? _StepState.current
            : _StepState.future,
        icon: Icons.event_available_rounded,
      ));
    } else {
      steps.add(_TimelineStep(
        title: tr('Đặt lịch học'),
        subtitle: '${friendlyDay(session.startTime, now)} · '
            '${formatTimeRange(session.startTime, session.durationMinutes)}',
        state: session.status == SessionStatus.scheduled
            ? _StepState.current
            : _StepState.done,
        icon: Icons.event_available_rounded,
      ));
    }

    final completed = request.completedSession;
    if (status == SwapStatus.completed && completed != null) {
      final reviewed = request.hasReviewed(currentUserId);
      steps.add(_TimelineStep(
        title: tr('Hoàn thành & đánh giá'),
        subtitle: reviewed
            ? tr('Bạn đã đánh giá buổi học')
            : tr('Đang chờ bạn đánh giá'),
        state: reviewed ? _StepState.done : _StepState.current,
        icon: Icons.verified_rounded,
      ));
    } else {
      steps.add(_TimelineStep(
        title: tr('Hoàn thành & đánh giá'),
        subtitle: tr('Sau khi buổi học kết thúc'),
        state: _StepState.future,
        icon: Icons.flag_rounded,
      ));
    }

    return steps;
  }

  Color _colorFor(_StepState state) {
    switch (state) {
      case _StepState.done:
        return AppColors.success;
      case _StepState.current:
        return AppColors.primary;
      case _StepState.future:
        return AppColors.slate;
      case _StepState.failed:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final color = _colorFor(step.state);
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 26,
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: step.state == _StepState.future
                            ? AppColors.background
                            : color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: step.state == _StepState.future
                              ? AppColors.border
                              : color.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Icon(step.icon, size: 13, color: color),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          color: (step.state == _StepState.future ||
                                  step.state == _StepState.failed)
                              ? AppColors.border
                              : AppColors.success.withValues(alpha: 0.28),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: step.state == _StepState.future
                              ? AppColors.muted
                              : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.45,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
