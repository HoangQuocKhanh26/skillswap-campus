import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../models/user.dart';
import '../services/matching_service.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../utils/actions.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/match_detail_sheet.dart';
import '../widgets/rating_bar.dart';
import '../widgets/status_badge.dart';
import '../widgets/user_avatar.dart';
import '../l10n/app_text.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final incoming = state.incomingPending;
    final outgoing = state.outgoingPending;
    final history = state.historyRequests;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr('Yêu cầu ghép đôi')),
          bottom: TabBar(
            tabs: [
              Tab(
                text: incoming.isEmpty
                    ? tr('Nhận được')
                    : trArgs(
                        'Nhận được ({count})',
                        {'count': '${incoming.length}'},
                      ),
              ),
              Tab(
                text: outgoing.isEmpty
                    ? tr('Đã gửi')
                    : trArgs(
                        'Đã gửi ({count})',
                        {'count': '${outgoing.length}'},
                      ),
              ),
              Tab(text: tr('Lịch sử')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _IncomingTab(requests: incoming),
            _OutgoingTab(requests: outgoing),
            _HistoryTab(requests: history),
          ],
        ),
      ),
    );
  }
}

class _IncomingTab extends StatelessWidget {
  final List<SwapRequest> requests;

  const _IncomingTab({required this.requests});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return EmptyState(
        icon: Icons.mark_email_read_outlined,
        title: tr('Chưa có lời mời nào'),
        message:
            tr('Khi có bạn học muốn trao đổi kỹ năng, lời mời sẽ xuất hiện ở đây. '
            'Bạn có 48 giờ để phản hồi trước khi lời mời hết hạn.'),
        color: AppColors.info,
      );
    }

    return RefreshIndicator(
      onRefresh: () async =>
          AppScope.read(context).expireOverdueRequests(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: requests.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) return const _ExpiryHint();
          return _IncomingCard(request: requests[index - 1]);
        },
      ),
    );
  }
}

class _IncomingCard extends StatelessWidget {
  final SwapRequest request;

  const _IncomingCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser!;
    final partner = state.userById(request.otherUserId(me.id));
    final result = const MatchingService().evaluate(
      currentUser: me,
      candidate: partner,
    );
    final left = request.expiresAt.difference(state.now);
    final urgent = left.inHours < 8;

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
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAvatar(user: partner, size: 48, showOnline: true),
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
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            RatingStars(
                              rating: partner.rating,
                              size: 11,
                              showValue: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${partner.subtitle} · ${timeAgo(request.createdAt, state.now)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  SoftBadge(
                    label: timeLeft(request.expiresAt, state.now),
                    color: urgent ? AppColors.danger : AppColors.accent,
                    icon: Icons.timer_outlined,
                    compact: true,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '“${request.message}”',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              _MatchLine(result: result, partner: partner),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => rejectFlow(context, state, request),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 42),
                        foregroundColor: AppColors.danger,
                      ),
                      child: Text(tr('Từ chối')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () => acceptFlow(context, state, request),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 42),
                      ),
                      icon: const Icon(Icons.check_rounded, size: 17),
                      label: Text(tr('Chấp nhận')),
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

class _OutgoingTab extends StatelessWidget {
  final List<SwapRequest> requests;

  const _OutgoingTab({required this.requests});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return EmptyState(
        icon: Icons.outbox_rounded,
        title: tr('Chưa gửi lời mời nào'),
        message:
            tr('Hãy sang tab Khám phá, vuốt sang phải hoặc bấm Kết nối để gửi lời mời tới người phù hợp.'),
        color: AppColors.primary,
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: requests.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) return const _ExpiryHint(outgoing: true);
        return _OutgoingCard(request: requests[index - 1]);
      },
    );
  }
}

class _OutgoingCard extends StatelessWidget {
  final SwapRequest request;

  const _OutgoingCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser!;
    final partner = state.userById(request.otherUserId(me.id));
    final result = const MatchingService().evaluate(
      currentUser: me,
      candidate: partner,
    );

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
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  UserAvatar(user: partner, size: 48),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trArgs(
                            'Bạn → {name}',
                            {'name': partner.name},
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          trArgs(
                            'Đã gửi {time} · {left}',
                            {
                              'time': timeAgo(request.createdAt, state.now),
                              'left': timeLeft(request.expiresAt, state.now),
                            },
                          ),
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const StatusBadge(SwapStatus.pending, compact: true),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '“${request.message}”',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.5,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),
              _MatchLine(result: result, partner: partner),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: () => cancelFlow(context, state, request),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.muted,
                    ),
                    child: Text(tr('Thu hồi')),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () =>
                        partnerAcceptedFlow(context, state, request),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    icon: const Icon(Icons.science_outlined, size: 15),
                    label: Text(
                      tr('Demo: đồng ý'),
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

class _HistoryTab extends StatelessWidget {
  final List<SwapRequest> requests;

  const _HistoryTab({required this.requests});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return EmptyState(
        icon: Icons.history_rounded,
        title: tr('Chưa có lịch sử ghép đôi'),
        message:
            tr('Các lời mời đã chấp nhận, từ chối, hết hạn, huỷ hoặc hoàn thành sẽ được lưu ở đây.'),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: requests.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          _HistoryCard(request: requests[index]),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final SwapRequest request;

  const _HistoryCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser!;
    final partner = state.userById(request.otherUserId(me.id));
    final status = state.statusOf(request);
    final session = request.latestSession;
    final needsReview = request.needsMyReview(me.id);

    String subtitle;
    switch (status) {
      case SwapStatus.accepted:
        subtitle = tr('Đã ghép đôi · chưa chọn lịch');
        break;
      case SwapStatus.scheduled:
        subtitle = session != null
            ? '${friendlyDay(session.startTime, state.now)} · '
                '${formatTime(session.startTime)}'
            : tr('Đã đặt lịch');
        break;
      case SwapStatus.completed:
        subtitle = session != null
            ? trArgs(
                'Hoàn thành {time}',
                {'time': timeAgo(session.startTime, state.now)},
              )
            : tr('Đã hoàn thành');
        break;
      case SwapStatus.rejected:
        subtitle = trArgs(
          'Đã từ chối {time}',
          {
            'time': timeAgo(
              request.respondedAt ?? request.createdAt,
              state.now,
            ),
          },
        );
        break;
      case SwapStatus.expired:
        subtitle = trArgs(
          'Hết hạn {time}',
          {'time': timeAgo(request.expiresAt, state.now)},
        );
        break;
      case SwapStatus.cancelled:
        subtitle = request.cancelReason?.isNotEmpty == true
            ? trArgs(
                'Lý do: {reason}',
                {'reason': request.cancelReason!},
              )
            : tr('Đã huỷ buổi trao đổi');
        break;
      case SwapStatus.pending:
        subtitle = tr('Đang chờ phản hồi');
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => MatchDetailSheet.show(context, request.id),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              UserAvatar(user: partner, size: 42),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            partner.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        StatusBadge(status, compact: true),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.muted,
                      ),
                    ),
                    if (needsReview) ...[
                      const SizedBox(height: 5),
                      SoftBadge(
                        label: tr('Chờ bạn đánh giá'),
                        color: AppColors.accent,
                        icon: Icons.star_outline_rounded,
                        compact: true,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.slate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchLine extends StatelessWidget {
  final MatchingResult result;
  final User partner;

  const _MatchLine({required this.result, required this.partner});

  @override
  Widget build(BuildContext context) {
    final theyTeach = result.theyTeachYou;
    final youTeach = result.youTeachThem;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.sync_alt_rounded,
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 10.5,
                height: 1.45,
                color: AppColors.muted,
              ),
              children: [
                TextSpan(text: tr('Họ dạy bạn ')),
                TextSpan(
                  text: theyTeach.isEmpty
                      ? '—'
                      : theyTeach.take(2).join(', '),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(text: tr('  ·  Bạn dạy họ ')),
                TextSpan(
                  text: youTeach.isEmpty
                      ? '—'
                      : youTeach.take(2).join(', '),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpiryHint extends StatelessWidget {
  final bool outgoing;

  const _ExpiryHint({this.outgoing = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.timer_outlined,
            size: 16,
            color: Color(0xFFB45309),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              outgoing
                  ? tr('Lời mời đã gửi sẽ tự động hết hạn sau 48 giờ nếu chưa có phản hồi. '
                      'Bạn có thể thu hồi bất cứ lúc nào.')
                  : tr('Lời mời nhận được có hiệu lực 48 giờ. Bạn có thể chấp nhận, '
                      'từ chối hoặc để hết hạn — mọi nhánh đều được lưu vào Lịch sử.'),
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.45,
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
