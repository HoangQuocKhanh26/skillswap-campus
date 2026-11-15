import 'package:flutter/material.dart';

import '../models/skill.dart';
import '../models/swap_request.dart';
import '../models/user.dart';
import '../services/matching_service.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/match_score_ring.dart';
import '../widgets/rating_bar.dart';
import '../widgets/skill_chip.dart';
import '../widgets/status_badge.dart';
import '../widgets/user_avatar.dart';
import 'edit_profile_screen.dart';
import '../l10n/app_text.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  SwapRequest? _activeRequest(AppState state, String partnerId) {
    for (final request in state.myRequests) {
      if (!request.involves(partnerId)) continue;
      final status = state.statusOf(request);
      if (status == SwapStatus.pending ||
          status == SwapStatus.accepted ||
          status == SwapStatus.scheduled ||
          status == SwapStatus.completed) {
        return request;
      }
    }
    return null;
  }

  Future<void> _openRequestSheet(
    BuildContext context,
    AppState state,
    User me,
  ) async {
    final message = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (_) => _RequestSheet(
        partner: user,
        me: me,
      ),
    );

    if (message == null || !context.mounted) return;

    final request = state.sendRequest(user, message: message);
    if (!context.mounted) return;
    if (request == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            trArgs(
              'Bạn đã có lời mời với {name}.',
              {'name': user.name},
            ),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          trArgs('Đã gửi lời mời tới {name}.', {'name': user.name}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser;
    final isMe = me?.id == user.id;
    final match = me == null || isMe
        ? null
        : const MatchingService().evaluate(
            currentUser: me,
            candidate: user,
          );
    final existing = me == null || isMe
        ? null
        : _activeRequest(state, user.id);
    final existingStatus =
        existing == null ? null : state.statusOf(existing);
    final rating = state.ratingOf(user.id);
    final reviewCount = state.reviewCountOf(user.id);
    final reviews = state.reviewsAbout(user.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 288,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: Text(
              tr('Hồ sơ sinh viên'),
              style: TextStyle(color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -50,
                      child: _circle(180, Colors.white.withValues(alpha: 0.06)),
                    ),
                    Positioned(
                      bottom: 38,
                      left: -40,
                      child: _circle(120, Colors.white.withValues(alpha: 0.05)),
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 48, 20, 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              UserAvatar(
                                user: user,
                                size: 86,
                                heroTag: 'avatar-${user.id}',
                                showRing: true,
                                showOnline: true,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${user.subtitle} · ${user.campus}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.78),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: AppColors.accent,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      trArgs(
                                        '({count} đánh giá)',
                                        {'count': '$reviewCount'},
                                      ),
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                        fontSize: 10.5,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 1,
                                      height: 10,
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.bolt_rounded,
                                      color: AppColors.accent,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      user.responseTime,
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.85),
                                        fontSize: 10.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardHeading(
                          icon: Icons.info_outline_rounded,
                          title: tr('Giới thiệu'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.bio.isEmpty
                              ? tr('Sinh viên này chưa cập nhật phần giới thiệu.')
                              : user.bio,
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.6,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              user.campus,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trArgs(
                                'Phản hồi {time}',
                                {'time': user.responseTime},
                              ),
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (match != null) ...[
                    const SizedBox(height: 12),
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _CardHeading(
                                icon: Icons.auto_awesome_rounded,
                                title: tr('Vì sao phù hợp?'),
                              ),
                              const Spacer(),
                              MatchScoreRing(
                                percent: match.percent,
                                size: 54,
                                showCaption: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            match.reason,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.5,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _MatchDirection(
                            title: tr('Họ có thể dạy bạn'),
                            skills: match.theyTeachYou,
                            color: AppColors.primary,
                            icon: Icons.arrow_downward_rounded,
                            emptyText: tr('Chưa có kỹ năng trùng với mục tiêu của bạn'),
                          ),
                          const SizedBox(height: 12),
                          _MatchDirection(
                            title: tr('Bạn có thể dạy họ'),
                            skills: match.youTeachThem,
                            color: AppColors.secondary,
                            icon: Icons.arrow_upward_rounded,
                            emptyText: tr('Đối phương chưa cần kỹ năng bạn đang có'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _SkillTabs(user: user),
                  const SizedBox(height: 12),
                  _ReviewsSection(reviews: reviews),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: isMe
              ? FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: Text(tr('Chỉnh sửa hồ sơ của tôi')),
                )
              : _buildActions(context, state, me!, existingStatus),
        ),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    AppState state,
    User me,
    SwapStatus? status,
  ) {
    if (status != null) {
      final label = switch (status) {
        SwapStatus.pending => trArgs(
            'Đang chờ {name} phản hồi',
            {'name': user.name},
          ),
        SwapStatus.accepted => tr('Đã ghép đôi · chọn lịch học trong tab Lịch hẹn'),
        SwapStatus.scheduled => trArgs(
            'Đã có lịch học với {name}',
            {'name': user.name},
          ),
        SwapStatus.completed => tr('Đã hoàn thành buổi trao đổi'),
        _ => status.label,
      };
      return Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor(status).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon(status),
              size: 20,
              color: statusColor(status),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        OutlinedButton(
          onPressed: () {
            state.skipUser(user.id);
            Navigator.of(context).pop();
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(46, 46),
            padding: EdgeInsets.zero,
          ),
          child: const Icon(Icons.close_rounded, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _openRequestSheet(context, state, me),
            icon: const Icon(Icons.handshake_rounded, size: 19),
            label: Text(tr('Gửi lời mời kết nối')),
          ),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _CardHeading extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CardHeading({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.primary),
        const SizedBox(width: 7),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _MatchDirection extends StatelessWidget {
  final String title;
  final List<String> skills;
  final Color color;
  final IconData icon;
  final String emptyText;

  const _MatchDirection({
    required this.title,
    required this.skills,
    required this.color,
    required this.icon,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.5,
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
              fontSize: 11.5,
              color: AppColors.muted,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: skills
                .map(
                  (skill) => SkillChip.fromString(
                    skill,
                    tone: color == AppColors.primary
                        ? SkillTone.learning
                        : SkillTone.teaching,
                    compact: true,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _SkillTabs extends StatelessWidget {
  final User user;

  const _SkillTabs({required this.user});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: tr('Có thể dạy')),
                Tab(text: tr('Muốn học')),
              ],
            ),
            SizedBox(
              height: 156,
              child: TabBarView(
                children: [
                  _SkillGrid(
                    skills: user.teachingSkills,
                    tone: SkillTone.teaching,
                  ),
                  _SkillGrid(
                    skills: user.learningSkills,
                    tone: SkillTone.learning,
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

class _SkillGrid extends StatelessWidget {
  final List<Skill> skills;
  final SkillTone tone;

  const _SkillGrid({required this.skills, required this.tone});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return Center(
        child: Text(
          tr('Chưa có kỹ năng nào'),
          style: TextStyle(fontSize: 12, color: AppColors.muted),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: skills
            .map((skill) => SkillChip(skill: skill, tone: tone))
            .toList(),
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final List<Review> reviews;

  const _ReviewsSection({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              tr('Đánh giá gần đây'),
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const Spacer(),
            Text(
              trArgs(
                '{count} đánh giá chi tiết',
                {'count': '${reviews.length}'},
              ),
              style: TextStyle(
                fontSize: 10.5,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (reviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18,
                  color: AppColors.slate,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tr('Chưa có đánh giá chi tiết. Một số đánh giá được ẩn trong bản demo.'),
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.45,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...reviews.take(3).map((review) {
            final reviewer = state.userById(review.fromUserId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UserAvatar(user: reviewer, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviewer.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              RatingStars(
                                rating: review.rating.toDouble(),
                                size: 11,
                                showValue: false,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          timeAgo(review.createdAt, state.now),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    if (review.comment.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(
                        review.comment,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _RequestSheet extends StatefulWidget {
  final User partner;
  final User me;

  const _RequestSheet({required this.partner, required this.me});

  @override
  State<_RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends State<_RequestSheet> {
  final _controller = TextEditingController();

  static List<String> get _suggestions => [
        tr('Chào bạn, mình thấy chúng ta có thể trao đổi kỹ năng. Bạn có rảnh buổi chiều thứ 5 không?'),
        tr('Mình muốn học kỹ năng của bạn và có thể dạy lại kỹ năng bạn đang cần. Cùng thử một buổi nhé?'),
        tr('Chào bạn! Mình đang tìm người học cùng để tiến bộ nhanh hơn. Bạn thấy thế nào?'),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 4,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              UserAvatar(user: widget.partner, size: 42),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('Gửi lời mời kết nối'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      trArgs(
                        'Tới {name} · hết hạn sau 48 giờ',
                        {'name': widget.partner.name},
                      ),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            maxLength: 220,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText:
                  tr('Viết lời nhắn ngắn: bạn muốn học gì, có thể dạy lại gì và thời gian rảnh...'),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                return ActionChip(
                  label: Text(
                    trArgs('Gợi ý {count}', {'count': '${index + 1}'}),
                  ),
                  avatar: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 14,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.text = _suggestions[index];
                      _controller.selection = TextSelection.collapsed(
                        offset: _controller.text.length,
                      );
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(
              _controller.text.trim(),
            ),
            icon: const Icon(Icons.send_rounded, size: 18),
            label: Text(tr('Gửi lời mời')),
          ),
          const SizedBox(height: 4),
          Text(
            tr('Đối phương có 48 giờ để chấp nhận, từ chối hoặc để lời mời hết hạn.'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.muted.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
