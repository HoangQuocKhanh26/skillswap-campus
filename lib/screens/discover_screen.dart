import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/matching_service.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/swap_candidate_card.dart';
import '../widgets/user_avatar.dart';
import 'user_detail_screen.dart';
import '../l10n/app_text.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _filter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MatchingResult> _applyFilters(List<MatchingResult> source) {
    final query = _query.trim().toLowerCase();
    return source.where((result) {
      final user = result.user;
      final skillText = [
        ...user.teachingSkills.map((skill) => skill.name),
        ...user.learningSkills.map((skill) => skill.name),
      ].join(' ').toLowerCase();

      final matchesQuery = query.isEmpty ||
          user.name.toLowerCase().contains(query) ||
          user.major.toLowerCase().contains(query) ||
          user.bio.toLowerCase().contains(query) ||
          skillText.contains(query);

      var matchesFilter = true;
      if (_filter == 'mutual') {
        matchesFilter = result.isMutual;
      } else if (_filter.startsWith('skill:')) {
        final skillName = _filter.substring(6);
        matchesFilter =
            user.teachingSkills.any((skill) => skill.name == skillName) ||
                result.theyTeachYou.contains(skillName);
      }

      return matchesQuery && matchesFilter;
    }).toList();
  }

  void _openDetail(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserDetailScreen(user: user),
      ),
    );
  }

  void _skip(User user) {
    final state = AppScope.read(context);
    state.skipUser(user.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            trArgs('Đã bỏ qua {name}', {'name': user.name}),
          ),
          action: SnackBarAction(
            label: tr('Hoàn tác'),
            textColor: Colors.white,
            onPressed: () => state.unskipUser(user.id),
          ),
        ),
      );
  }

  void _connect(User user) {
    final state = AppScope.read(context);
    final request = state.sendRequest(user);
    if (request == null) {
      state.skipUser(user.id);
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            trArgs(
              'Đã gửi lời mời tới {name} · chờ phản hồi trong 48 giờ',
              {'name': user.name},
            ),
          ),
        ),
      );
  }

  void _decide(User user, bool interested) {
    if (interested) {
      _connect(user);
    } else {
      _skip(user);
    }
  }

  void _clearFilters() {
    setState(() {
      _query = '';
      _filter = 'all';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser;
    if (me == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final recommendations = state.recommendations;
    final feed = _applyFilters(recommendations);
    final skillFilters = recommendations
        .expand((result) => result.user.teachingSkills)
        .map((skill) => skill.name)
        .toSet()
        .toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr('Khám phá')),
            Text(
              '${greetingFor(state.now)}, ${me.name} 👋',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => _openDetail(me),
              child: UserAvatar(user: me, size: 38, showRing: true),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: tr('Tìm tên, ngành hoặc kỹ năng...'),
                prefixIcon: const Icon(Icons.search_rounded, size: 21),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.close_rounded, size: 18),
                      ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChipItem(
                    label: tr('Tất cả'),
                    selected: _filter == 'all',
                    onTap: () => setState(() => _filter = 'all'),
                  ),
                  const SizedBox(width: 7),
                  _FilterChipItem(
                    label: tr('Trao đổi 2 chiều'),
                    icon: Icons.sync_alt_rounded,
                    selected: _filter == 'mutual',
                    onTap: () => setState(() => _filter = 'mutual'),
                  ),
                  const SizedBox(width: 7),
                  ...skillFilters.map(
                    (skill) => Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: _FilterChipItem(
                        label: skill,
                        selected: _filter == 'skill:$skill',
                        onTap: () => setState(() => _filter = 'skill:$skill'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  trArgs(
                    '{count} hồ sơ phù hợp',
                    {'count': '${feed.length}'},
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 13,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 4),
                Text(
                  tr('Sắp xếp theo độ phù hợp'),
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: feed.isEmpty
                  ? EmptyState(
                      icon: Icons.explore_off_rounded,
                      title: _query.isNotEmpty || _filter != 'all'
                          ? tr('Không tìm thấy hồ sơ phù hợp')
                          : tr('Bạn đã xem hết hồ sơ rồi!'),
                      message: _query.isNotEmpty || _filter != 'all'
                          ? tr('Thử xoá bộ lọc hoặc tìm bằng tên kỹ năng khác nhé.')
                          : tr('Các hồ sơ đã bỏ qua sẽ được đưa trở lại nếu bạn muốn xem lại.'),
                      actionLabel: _query.isNotEmpty || _filter != 'all'
                          ? tr('Xoá bộ lọc')
                          : tr('Xem lại tất cả hồ sơ'),
                      onAction: _query.isNotEmpty || _filter != 'all'
                          ? _clearFilters
                          : () => state.resetSkippedUsers(),
                    )
                  : _Deck(
                      feed: feed,
                      onDecide: _decide,
                      onOpenDetail: _openDetail,
                    ),
            ),
            if (feed.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: Icons.close_rounded,
                      label: tr('Bỏ qua'),
                      color: AppColors.danger,
                      background: Colors.white,
                      onTap: () => _skip(feed.first.user),
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: Icons.visibility_outlined,
                      label: tr('Chi tiết'),
                      color: AppColors.primary,
                      background: Colors.white,
                      small: true,
                      onTap: () => _openDetail(feed.first.user),
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: Icons.handshake_rounded,
                      label: tr('Kết nối'),
                      color: Colors.white,
                      background: AppColors.primary,
                      onTap: () => _connect(feed.first.user),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected ? Colors.white : AppColors.muted,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Deck extends StatelessWidget {
  final List<MatchingResult> feed;
  final void Function(User user, bool interested) onDecide;
  final void Function(User user) onOpenDetail;

  const _Deck({
    required this.feed,
    required this.onDecide,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final cards = feed.take(3).toList();

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        for (var index = cards.length - 1; index >= 1; index--)
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, 7.0 * index),
              child: Transform.scale(
                scale: 1 - (0.028 * index),
                alignment: Alignment.topCenter,
                child: IgnorePointer(
                  child: SwapCandidateCard(result: cards[index]),
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: Dismissible(
            key: ValueKey('candidate-${cards.first.user.id}'),
            direction: DismissDirection.horizontal,
            dismissThresholds: const {
              DismissDirection.startToEnd: 0.25,
              DismissDirection.endToStart: 0.25,
            },
            movementDuration: const Duration(milliseconds: 230),
            resizeDuration: const Duration(milliseconds: 160),
            background: _SwipeBackground(
              alignment: Alignment.centerLeft,
              color: AppColors.success,
              icon: Icons.handshake_rounded,
              label: tr('Gửi lời mời'),
            ),
            secondaryBackground: _SwipeBackground(
              alignment: Alignment.centerRight,
              color: AppColors.danger,
              icon: Icons.close_rounded,
              label: tr('Bỏ qua'),
            ),
            onDismissed: (direction) {
              onDecide(
                cards.first.user,
                direction == DismissDirection.startToEnd,
              );
            },
            child: SwapCandidateCard(
              result: cards.first,
              onTap: () => onOpenDetail(cards.first.user),
            ),
          ),
        ),
      ],
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;

  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final alignLeft = alignment == Alignment.centerLeft;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
          end: alignLeft ? Alignment.centerRight : Alignment.centerLeft,
          colors: [
            color.withValues(alpha: 0.92),
            color.withValues(alpha: 0.65),
          ],
        ),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 34),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final VoidCallback onTap;
  final bool small;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    required this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 46.0 : 56.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: background,
          shape: CircleBorder(
            side: BorderSide(
              color: background == Colors.white
                  ? color.withValues(alpha: 0.28)
                  : Colors.transparent,
            ),
          ),
          elevation: background == Colors.white ? 0 : 4,
          shadowColor: color.withValues(alpha: 0.4),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, size: small ? 20 : 26, color: color),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: background == Colors.white
                ? AppColors.muted
                : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
