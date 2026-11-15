import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../models/user.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/rating_bar.dart';
import '../widgets/skill_chip.dart';
import '../widgets/user_avatar.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser;
    if (me == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Hồ sơ của tôi')),
        actions: [
          IconButton(
            tooltip: tr('Cài đặt'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            ),
            icon: const Icon(Icons.settings_outlined, size: 20),
          ),
          IconButton(
            tooltip: tr('Chỉnh sửa hồ sơ'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const EditProfileScreen(),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 21),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          _ProfileHeader(me: me, state: state),
          const SizedBox(height: 12),
          _StatsCard(me: me),
          const SizedBox(height: 4),
          SectionTitle(
            tr('Kỹ năng của tôi'),
            padding: EdgeInsets.fromLTRB(4, 20, 4, 10),
          ),
          _SkillsCard(me: me),
          SectionTitle(
            tr('Đánh giá nhận được'),
            padding: EdgeInsets.fromLTRB(4, 20, 4, 10),
          ),
          _ReceivedReviews(reviews: state.reviewsAboutMe),
          SectionTitle(
            tr('Kịch bản demo'),
            padding: EdgeInsets.fromLTRB(4, 20, 4, 10),
          ),
          _DemoTools(state: state),
          const SizedBox(height: 18),
          Center(
            child: Text(
              tr('SkillSwap Campus · bản demo môn học\nDữ liệu sinh viên là giả lập'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                height: 1.5,
                color: AppColors.muted.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User me;
  final AppState state;

  const _ProfileHeader({required this.me, required this.state});

  @override
  Widget build(BuildContext context) {
    final rating = state.ratingOf(me.id);
    final reviewCount = state.reviewCountOf(me.id);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                user: me,
                size: 72,
                showRing: true,
                showOnline: true,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      me.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      me.subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _TinyChip(
                          icon: Icons.star_rounded,
                          label: reviewCount == 0
                              ? tr('Chưa có đánh giá')
                              : trArgs(
                                  '{rating} · {count} đánh giá',
                                  {
                                    'rating': rating.toStringAsFixed(1),
                                    'count': '$reviewCount',
                                  },
                                ),
                          color: AppColors.accent,
                        ),
                        _TinyChip(
                          icon: Icons.school_rounded,
                          label: trArgs(
                            'Dạy {count}',
                            {'count': '${me.teachingSkills.length}'},
                          ),
                          color: Colors.white,
                        ),
                        _TinyChip(
                          icon: Icons.menu_book_rounded,
                          label: trArgs(
                            'Học {count}',
                            {'count': '${me.learningSkills.length}'},
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              me.bio.isEmpty
                  ? tr('Chưa có giới thiệu. Bấm chỉnh sửa để thêm vài dòng về bạn.')
                  : me.bio,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11.5,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 42),
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
                backgroundColor: Colors.white.withValues(alpha: 0.08),
              ),
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: Text(
                tr('Chỉnh sửa hồ sơ'),
                style: TextStyle(fontSize: 12.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TinyChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final User me;

  const _StatsCard({required this.me});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final rating = state.ratingOf(me.id);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: StatTile(
              value: '${state.completedSessionCount}',
              label: tr('Buổi hoàn thành'),
              icon: Icons.task_alt_rounded,
              color: AppColors.success,
            ),
          ),
          _divider(),
          Expanded(
            child: StatTile(
              value: '${state.partnerCount}',
              label: tr('Đối tác học'),
              icon: Icons.people_alt_rounded,
              color: AppColors.primary,
            ),
          ),
          _divider(),
          Expanded(
            child: StatTile(
              value: rating == 0 ? '—' : rating.toStringAsFixed(1),
              label: tr('Đánh giá TB'),
              icon: Icons.star_rounded,
              color: AppColors.accent,
            ),
          ),
          _divider(),
          Expanded(
            child: StatTile(
              value: '${state.needsReviewCount}',
              label: tr('Chờ đánh giá'),
              icon: Icons.rate_review_rounded,
              color: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        color: AppColors.border,
      );
}

class _SkillsCard extends StatelessWidget {
  final User me;

  const _SkillsCard({required this.me});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  text: trArgs(
                    'Tôi dạy ({count})',
                    {'count': '${me.teachingSkills.length}'},
                  ),
                ),
                Tab(
                  text: trArgs(
                    'Tôi muốn học ({count})',
                    {'count': '${me.learningSkills.length}'},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 148,
              child: TabBarView(
                children: [
                  _MySkills(
                    skills: me.teachingSkills,
                    tone: SkillTone.teaching,
                    emptyText: tr('Chưa có kỹ năng dạy'),
                  ),
                  _MySkills(
                    skills: me.learningSkills,
                    tone: SkillTone.learning,
                    emptyText: tr('Chưa có kỹ năng muốn học'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              ),
              icon: const Icon(Icons.tune_rounded, size: 16),
              label: Text(
                tr('Cập nhật kỹ năng'),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MySkills extends StatelessWidget {
  final List<dynamic> skills;
  final SkillTone tone;
  final String emptyText;

  const _MySkills({
    required this.skills,
    required this.tone,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: TextStyle(fontSize: 11.5, color: AppColors.muted),
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

class _ReceivedReviews extends StatelessWidget {
  final List<Review> reviews;

  const _ReceivedReviews({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    if (reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 20,
              color: AppColors.slate,
            ),
            SizedBox(width: 9),
            Expanded(
              child: Text(
                tr('Chưa có đánh giá nào. Hoàn thành buổi học đầu tiên để nhận đánh giá từ đối phương.'),
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.45,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: reviews.take(3).map((review) {
        final reviewer = state.userById(review.fromUserId);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
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
                        Text(
                          trArgs(
                            'Đánh giá {time}',
                            {
                              'time': timeAgo(review.createdAt, state.now),
                            },
                          ),
                          style: TextStyle(
                            fontSize: 9.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RatingStars(
                    rating: review.rating.toDouble(),
                    size: 12,
                    showValue: false,
                  ),
                ],
              ),
              if (review.comment.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '“${review.comment}”',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
              if (review.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: review.tags
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
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _DemoTools extends StatelessWidget {
  final AppState state;

  const _DemoTools({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.science_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  tr('Dữ liệu demo đã bao gồm đủ các nhánh: chờ phản hồi, đã ghép đôi, '
                  'đã đặt lịch, hoàn thành, bị từ chối, hết hạn và đã huỷ. '
                  'Dùng các nút bên dưới để thuyết trình.'),
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    state.resetSkippedUsers();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr('Đã khôi phục các hồ sơ đã bỏ qua.')),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(Icons.restore_rounded, size: 15),
                  label: Text(
                    tr('Khôi phục hồ sơ'),
                    style: TextStyle(fontSize: 10.5),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _reset(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 15),
                  label: Text(
                    tr('Reset dữ liệu'),
                    style: TextStyle(fontSize: 10.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                foregroundColor: AppColors.danger,
                side: BorderSide(
                  color: AppColors.danger.withValues(alpha: 0.25),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, size: 15),
              label: Text(
                tr('Đăng xuất'),
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _reset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr('Đặt lại dữ liệu demo?')),
        content: Text(
          tr('Toàn bộ lời mời, lịch học và đánh giá sẽ trở về trạng thái ban đầu. '
          'Hồ sơ của bạn vẫn được giữ nguyên.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(tr('Huỷ')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(tr('Đặt lại')),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      state.resetDemo();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('Đã reset dữ liệu demo về ban đầu.'))),
      );
    }
  }

  void _logout(BuildContext context) {
    state.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
