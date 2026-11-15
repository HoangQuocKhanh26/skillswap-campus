import 'dart:async';

import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import 'discover_screen.dart';
import 'profile_screen.dart';
import 'requests_screen.dart';
import 'schedule_screen.dart';
import '../l10n/app_text.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  Timer? _timer;

  static const List<Widget> _screens = [
    DiscoverScreen(),
    RequestsScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer ??= Timer.periodic(
      const Duration(minutes: 1),
      (_) => AppScope.read(context).expireOverdueRequests(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final pending = state.pendingIncomingCount;
    final reviews = state.needsReviewCount;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.03),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) {
            AppScope.read(context).expireOverdueRequests();
            setState(() => _index = value);
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: tr('Khám phá'),
            ),
            NavigationDestination(
              icon: _NavBadge(
                count: pending,
                child: const Icon(Icons.swap_horiz_rounded),
              ),
              selectedIcon: _NavBadge(
                count: pending,
                child: const Icon(Icons.swap_horiz_rounded),
              ),
              label: tr('Yêu cầu'),
            ),
            NavigationDestination(
              icon: _NavBadge(
                count: reviews,
                color: AppColors.accent,
                child: const Icon(Icons.calendar_month_outlined),
              ),
              selectedIcon: _NavBadge(
                count: reviews,
                color: AppColors.accent,
                child: const Icon(Icons.calendar_month_rounded),
              ),
              label: tr('Lịch hẹn'),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: tr('Hồ sơ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final Color? color;

  const _NavBadge({
    required this.count,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 26,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          child,
          if (count > 0)
            Positioned(
              top: -2,
              right: -4,
              child: CountBadge(
                count: count,
                color: color ?? AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
