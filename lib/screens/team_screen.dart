import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  static const String _repoUrl =
      'https://github.com/HoangQuocKhanh26/skillswap-campus';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Nhóm 12'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          const _TeamHero(),
          SectionTitle(
            tr('Thành viên'),
            padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
          ),
          _MemberCard(
            name: 'Hoàng Quốc Khánh',
            initials: 'HK',
            role: 'Nhóm trưởng',
            tasks: 'Kiến trúc, state, matching, lời mời, lịch hẹn, Git/README',
            percent: 40,
            color: AppColors.primary,
          ),
          const SizedBox(height: 10),
          _MemberCard(
            name: 'Đặng Tuấn Ngọc',
            initials: 'TN',
            role: 'Thành viên nhóm',
            tasks: 'Hồ sơ, onboarding, chi tiết, đánh giá, dữ liệu mẫu',
            percent: 35,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 10),
          _MemberCard(
            name: 'Đinh Trung Kiên',
            initials: 'TK',
            role: 'Thành viên nhóm',
            tasks: 'Báo cáo Word & PowerPoint',
            percent: 15,
            color: AppColors.accent,
          ),
          const SizedBox(height: 10),
          _MemberCard(
            name: 'Lê Quốc Anh',
            initials: 'QA',
            role: 'Thành viên nhóm',
            tasks: 'Khám phá, swipe card',
            percent: 10,
            color: AppColors.info,
          ),
          const SizedBox(height: 12),
          Text(
            tr('Tỷ lệ đóng góp theo thống nhất của nhóm.'),
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              height: 1.45,
              color: AppColors.muted,
            ),
          ),
          SectionTitle(
            tr('Thông tin dự án'),
            padding: const EdgeInsets.fromLTRB(4, 24, 4, 10),
          ),
          _ProjectCard(repoUrl: _repoUrl),
        ],
      ),
    );
  }
}

class _TeamHero extends StatelessWidget {
  const _TeamHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('Nhóm 12'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tr('Đồ án môn Lập trình thiết bị di động'),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.phone_iphone_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    tr('SkillSwap Campus · Flutter · 4 thành viên'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
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

class _MemberCard extends StatelessWidget {
  final String name;
  final String initials;
  final String role;
  final String tasks;
  final int percent;
  final Color color;

  const _MemberCard({
    required this.name,
    required this.initials,
    required this.role,
    required this.tasks,
    required this.percent,
    required this.color,
  });

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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tr(role),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      tr(tasks),
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.45,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 6,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String repoUrl;

  const _ProjectCard({required this.repoUrl});

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: repoUrl));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr('Đã sao chép liên kết mã nguồn.'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProjectRow(
            icon: Icons.apps_rounded,
            label: tr('Dự án'),
            value: 'SkillSwap Campus',
          ),
          const SizedBox(height: 13),
          _ProjectRow(
            icon: Icons.calendar_month_rounded,
            label: tr('Phiên bản'),
            value: '1.0.0',
          ),
          const SizedBox(height: 13),
          _ProjectRow(
            icon: Icons.info_outline_rounded,
            label: tr('Dữ liệu'),
            value: tr('Giả lập, không có backend'),
          ),
          const SizedBox(height: 15),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 13),
          Text(
            tr('Mã nguồn'),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  repoUrl,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: tr('Sao chép liên kết'),
                onPressed: () => _copy(context),
                icon: Icon(
                  Icons.copy_rounded,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            tr('Dữ liệu trong app là giả lập, không có backend.'),
            style: TextStyle(
              fontSize: 10.5,
              height: 1.45,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProjectRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.muted),
        const SizedBox(width: 9),
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              color: AppColors.muted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
