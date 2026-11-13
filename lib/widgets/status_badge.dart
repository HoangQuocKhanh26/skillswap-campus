import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../theme/app_theme.dart';

Color statusColor(SwapStatus status) {
  switch (status) {
    case SwapStatus.pending:
      return AppColors.accent;
    case SwapStatus.accepted:
      return AppColors.info;
    case SwapStatus.scheduled:
      return AppColors.primary;
    case SwapStatus.completed:
      return AppColors.success;
    case SwapStatus.rejected:
      return AppColors.danger;
    case SwapStatus.expired:
      return AppColors.slate;
    case SwapStatus.cancelled:
      return AppColors.slate;
  }
}

IconData statusIcon(SwapStatus status) {
  switch (status) {
    case SwapStatus.pending:
      return Icons.hourglass_top_rounded;
    case SwapStatus.accepted:
      return Icons.handshake_rounded;
    case SwapStatus.scheduled:
      return Icons.event_available_rounded;
    case SwapStatus.completed:
      return Icons.verified_rounded;
    case SwapStatus.rejected:
      return Icons.close_rounded;
    case SwapStatus.expired:
      return Icons.timer_off_rounded;
    case SwapStatus.cancelled:
      return Icons.block_rounded;
  }
}

class StatusBadge extends StatelessWidget {
  final SwapStatus status;
  final bool compact;

  const StatusBadge(this.status, {super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return SoftBadge(
      label: status.label,
      color: statusColor(status),
      icon: statusIcon(status),
      compact: compact,
    );
  }
}

class SoftBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool compact;

  const SoftBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 9,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 11 : 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10.5 : 11.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class CountBadge extends StatelessWidget {
  final int count;
  final Color color;

  const CountBadge({
    super.key,
    required this.count,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 9 ? '9+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
