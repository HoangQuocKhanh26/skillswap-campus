import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../state/app_scope.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/rating_bar.dart';
import '../widgets/skill_chip.dart';
import '../widgets/user_avatar.dart';
import '../l10n/app_text.dart';

class ReviewSheet extends StatefulWidget {
  final SwapRequest request;

  const ReviewSheet({
    super.key,
    required this.request,
  });

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
  final _commentController = TextEditingController();
  final Set<String> _tags = {};
  int _rating = 5;
  bool _submitted = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) return;
    final state = AppScope.read(context);
    final ok = state.submitReview(
      widget.request.id,
      rating: _rating,
      comment: _commentController.text,
      tags: _tags.toList(),
    );
    if (ok) {
      setState(() => _submitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final me = state.currentUser!;
    final partnerId = widget.request.otherUserId(me.id);
    final partner = state.userById(partnerId);
    final session =
        widget.request.completedSession ?? widget.request.latestSession;
    final partnerReview = widget.request.reviewBy(partnerId);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: _submitted
          ? _SuccessView(
              partnerName: partner.name,
              rating: _rating,
              partnerReview: partnerReview,
              onClose: () => Navigator.of(context).pop(true),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      UserAvatar(user: partner, size: 46),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr('Đánh giá buổi học'),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              '${trArgs('Với {name}', {'name': partner.name})}'
                              '${session != null ? ' · ${formatShortDate(session.startTime)}' : ''}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tr('2 chiều'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        RatingBar(
                          rating: _rating,
                          onChanged: (value) => setState(() {
                            _rating = value;
                          }),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tr('Điều gì làm buổi học tốt?'),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: ReviewTags.positive.map((tag) {
                      final selected = _tags.contains(tag);
                      return FilterChip(
                        selected: selected,
                        label: Text(tr(tag)),
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.ink,
                        ),
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _tags.add(tag);
                            } else {
                              _tags.remove(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    maxLength: 200,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText:
                          tr('Chia sẻ cụ thể điều bạn thích hoặc cần cải thiện...'),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.swap_horiz_rounded,
                          size: 17,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            tr('Đánh giá hai chiều: sau khi gửi, bạn cũng sẽ nhận được '
                            'đánh giá từ đối phương.'),
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.45,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.star_rounded, size: 19),
                    label: Text(tr('Gửi đánh giá')),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String partnerName;
  final int rating;
  final Review? partnerReview;
  final VoidCallback onClose;

  const _SuccessView({
    required this.partnerName,
    required this.rating,
    required this.partnerReview,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 38,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          tr('Cảm ơn bạn đã đánh giá!'),
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          trArgs(
            'Bạn đã chấm {rating}/5 sao cho {name}.',
            {'rating': '$rating', 'name': partnerName},
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.muted,
          ),
        ),
        if (partnerReview != null) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      trArgs(
                        '{name} đã đánh giá bạn',
                        {'name': partnerName},
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const Spacer(),
                    RatingStars(
                      rating: partnerReview!.rating.toDouble(),
                      size: 12,
                      showValue: false,
                    ),
                  ],
                ),
                if (partnerReview!.comment.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    '“${partnerReview!.comment}”',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.5,
                      color: AppColors.muted,
                    ),
                  ),
                ],
                if (partnerReview!.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: partnerReview!.tags
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
          ),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onClose,
            child: const Text('Xong'),
          ),
        ),
      ],
    );
  }
}
