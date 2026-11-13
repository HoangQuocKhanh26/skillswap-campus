import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Hiển thị điểm đánh giá dạng sao (chỉ đọc).
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;
  final int? reviewCount;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 15,
    this.showValue = true,
    this.reviewCount,
    this.color = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    final rounded = (rating * 2).round() / 2;
    final full = rounded.floor();
    final hasHalf = rounded - full >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < 5; index++)
          Padding(
            padding: EdgeInsets.only(right: size * 0.08),
            child: Icon(
              index < full
                  ? Icons.star_rounded
                  : (index == full && hasHalf
                      ? Icons.star_half_rounded
                      : Icons.star_outline_rounded),
              size: size,
              color: index < full || (index == full && hasHalf)
                  ? color
                  : AppColors.border,
            ),
          ),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.86,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          if (reviewCount != null)
            Text(
              ' (${reviewCount!})',
              style: TextStyle(
                fontSize: size * 0.78,
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ],
    );
  }
}

/// Widget RatingBar cho phép chọn 1–5 sao (dùng khi đánh giá buổi học).
class RatingBar extends StatefulWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;
  final String? activeLabel;

  const RatingBar({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 42,
    this.activeLabel,
  });

  static const List<String> labels = [
    'Chưa hài lòng',
    'Cần cải thiện',
    'Bình thường',
    'Tốt',
    'Tuyệt vời',
  ];

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    final display = _hovered ?? widget.rating;
    final label = display > 0
        ? (widget.activeLabel ?? RatingBar.labels[display - 1])
        : 'Chạm để chọn số sao';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final value = index + 1;
            final filled = value <= display;
            return MouseRegion(
              onEnter: (_) => setState(() => _hovered = value),
              onExit: (_) => setState(() => _hovered = null),
              child: GestureDetector(
                onTap: () => widget.onChanged(value),
                behavior: HitTestBehavior.opaque,
                child: AnimatedScale(
                  scale: filled ? 1 : 0.92,
                  duration: const Duration(milliseconds: 160),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: widget.size,
                      color: filled ? AppColors.accent : AppColors.border,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            label,
            key: ValueKey(label),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: display > 0 ? AppColors.ink : AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}
