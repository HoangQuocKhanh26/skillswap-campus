import 'package:flutter/material.dart';

import '../l10n/app_text.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import 'team_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Cài đặt')),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          const _BrandCard(),
          SectionTitle(
            tr('Ngôn ngữ'),
            padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
          ),
          _LanguageCard(state: state),
          SectionTitle(
            tr('Chế độ giao diện'),
            padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
          ),
          _ThemeCard(state: state),
          SectionTitle(
            tr('Thông tin'),
            padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
          ),
          const _TeamEntry(),
          const SizedBox(height: 12),
          const _AboutCard(),
        ],
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('Cài đặt'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr('Tuỳ chỉnh ngôn ngữ, giao diện và xem thông tin nhóm.'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 12.5,
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

class _LanguageCard extends StatelessWidget {
  final AppState state;

  const _LanguageCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      children: [
        _LanguageOption(
          badge: 'VI',
          label: 'Tiếng Việt',
          subtitle: 'Ngôn ngữ mặc định của ứng dụng',
          selected: state.languageCode == 'vi',
          onTap: () => state.setLanguage('vi'),
        ),
        const _SettingDivider(),
        _LanguageOption(
          badge: 'EN',
          label: 'English',
          subtitle: 'English interface for presentations',
          selected: state.languageCode == 'en',
          onTap: () => state.setLanguage('en'),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String badge;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.badge,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primarySoft : AppColors.background,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: 1.2,
                ),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: selected ? AppColors.primary : AppColors.muted,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(label),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tr(subtitle),
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _CheckMark(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final AppState state;

  const _ThemeCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThemeOption(
            icon: Icons.light_mode_rounded,
            label: tr('Sáng'),
            description: tr('Nền sáng, dễ đọc ban ngày'),
            previewBackground: const Color(0xFFF6F6FB),
            previewSurface: Colors.white,
            previewInk: const Color(0xFF191833),
            selected: !state.isDark,
            onTap: () => state.setDarkMode(false),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ThemeOption(
            icon: Icons.dark_mode_rounded,
            label: tr('Tối'),
            description: tr('Dịu mắt khi học buổi tối'),
            previewBackground: const Color(0xFF0F111A),
            previewSurface: const Color(0xFF181B2A),
            previewInk: const Color(0xFFF3F1FB),
            selected: state.isDark,
            onTap: () => state.setDarkMode(true),
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color previewBackground;
  final Color previewSurface;
  final Color previewInk;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.previewBackground,
    required this.previewSurface,
    required this.previewInk,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 66,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: previewBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 7,
                    decoration: BoxDecoration(
                      color: previewInk.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    width: double.infinity,
                    height: 28,
                    decoration: BoxDecoration(
                      color: previewSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: previewInk.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const Spacer(),
                _CheckMark(selected: selected, size: 18),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              description,
              style: TextStyle(
                fontSize: 10.5,
                height: 1.35,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckMark extends StatelessWidget {
  final bool selected;
  final double size;

  const _CheckMark({required this.selected, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: 1.4,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
          : null,
    );
  }
}

class _TeamEntry extends StatelessWidget {
  const _TeamEntry();

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TeamScreen()),
          ),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.brandGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('Nhóm phát triển'),
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tr('Nhóm 12 · 4 thành viên · Flutter'),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.muted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      children: [
        _InfoRow(
          icon: Icons.school_outlined,
          label: tr('Đồ án môn Lập trình thiết bị di động'),
        ),
        const _SettingDivider(),
        _InfoRow(
          icon: Icons.new_releases_outlined,
          label: tr('Phiên bản 1.0.0'),
        ),
        const _SettingDivider(),
        _InfoRow(
          icon: Icons.info_outline_rounded,
          label: tr('Dữ liệu trong app là giả lập, không có backend.'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.muted),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingDivider extends StatelessWidget {
  const _SettingDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 14,
      endIndent: 14,
      color: AppColors.border,
    );
  }
}
