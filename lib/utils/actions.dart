import 'package:flutter/material.dart';

import '../models/swap_request.dart';
import '../screens/schedule_session_screen.dart';
import '../state/app_state.dart';
import '../widgets/review_sheet.dart';
import '../l10n/app_text.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> openSchedule(
  BuildContext context,
  SwapRequest request,
) async {
  final saved = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => ScheduleSessionScreen(request: request),
    ),
  );
  if (saved == true && context.mounted) {
    showMessage(context, tr('Đã lưu lịch học và thông báo cho đối phương (demo).'));
  }
}

Future<void> openReview(
  BuildContext context,
  SwapRequest request,
) async {
  final submitted = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ReviewSheet(request: request),
  );
  if (submitted == true && context.mounted) {
    showMessage(context, tr('Đánh giá của bạn đã được ghi lại.'));
  }
}

Future<void> acceptFlow(
  BuildContext context,
  AppState state,
  SwapRequest request,
) async {
  final partner = state.userById(request.otherUserId(state.currentUser!.id));
  state.respondToRequest(request.id, accept: true);
  if (!context.mounted) return;

  final updated = state.requestById(request.id);
  final goSchedule = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.handshake_rounded,
          color: Color(0xFF10B981),
          size: 28,
        ),
      ),
      title: Text(tr('Đã ghép đôi!')),
      content: Text(
        trArgs(
          'Bạn và {name} đã đồng ý trao đổi kỹ năng. Hãy chọn thời gian để buổi học diễn ra thuận lợi nhé.',
          {'name': partner.name},
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(tr('Để sau')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(tr('Chọn lịch ngay')),
        ),
      ],
    ),
  );

  if (goSchedule == true && updated != null && context.mounted) {
    await openSchedule(context, updated);
  }
}

/// Demo nhánh "đối phương đồng ý" cho lời mời đã gửi.
Future<void> partnerAcceptedFlow(
  BuildContext context,
  AppState state,
  SwapRequest request,
) async {
  final partner = state.userById(request.otherUserId(state.currentUser!.id));
  state.demoPartnerAccepts(request.id);
  if (!context.mounted) return;

  final updated = state.requestById(request.id);
  final goSchedule = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(
        Icons.mark_email_read_rounded,
        size: 36,
        color: Color(0xFF3B82F6),
      ),
      title: Text(
        trArgs('{name} đã đồng ý!', {'name': partner.name}),
      ),
      content: Text(
        tr('Đây là phản hồi mô phỏng cho buổi demo. '
        'Bạn có thể chọn lịch học ngay bây giờ.'),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(tr('Để sau')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(tr('Chọn lịch')),
        ),
      ],
    ),
  );

  if (goSchedule == true && updated != null && context.mounted) {
    await openSchedule(context, updated);
  }
}

Future<void> rejectFlow(
  BuildContext context,
  AppState state,
  SwapRequest request,
) async {
  final partner = state.userById(request.otherUserId(state.currentUser!.id));
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(tr('Từ chối lời mời?')),
      content: Text(
        trArgs(
          'Lời mời của {name} sẽ chuyển vào mục Lịch sử. Bạn vẫn có thể gửi lời mời mới sau này.',
          {'name': partner.name},
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(tr('Giữ lại')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
          child: Text(tr('Từ chối')),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    state.respondToRequest(request.id, accept: false);
    if (context.mounted) {
      showMessage(
        context,
        trArgs('Đã từ chối lời mời của {name}.', {'name': partner.name}),
      );
    }
  }
}

Future<void> cancelFlow(
  BuildContext context,
  AppState state,
  SwapRequest request,
) async {
  final controller = TextEditingController(text: tr('Bận lịch cá nhân'));
  final reason = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(tr('Huỷ buổi trao đổi?')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('Đối phương sẽ nhận được thông báo huỷ kèm lý do. '
            'Bạn có thể gửi lời mời mới sau.'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            maxLength: 120,
            decoration: InputDecoration(
              labelText: tr('Lý do huỷ'),
              hintText: tr('Ví dụ: bận lịch thi giữa kỳ'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(tr('Giữ lịch')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(
            controller.text.trim().isEmpty
                ? trArgs(
                    'Đã huỷ bởi {name}',
                    {'name': state.currentUser?.name ?? tr('sinh viên')},
                  )
                : controller.text.trim(),
          ),
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
          child: Text(tr('Xác nhận huỷ')),
        ),
      ],
    ),
  );
  controller.dispose();

  if (reason != null) {
    state.cancelMatch(request.id, reason: reason);
    if (context.mounted) {
      showMessage(context, tr('Đã huỷ buổi trao đổi.'));
    }
  }
}

Future<void> completeFlow(
  BuildContext context,
  AppState state,
  SwapRequest request,
) async {
  final partner = state.userById(request.otherUserId(state.currentUser!.id));
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(tr('Kết thúc buổi học?')),
      content: Text(
        trArgs(
          'Xác nhận buổi học với {name} đã diễn ra. Sau đó cả hai có thể đánh giá nhau (demo).',
          {'name': partner.name},
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(tr('Chưa kết thúc')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(tr('Đã hoàn thành')),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    state.completeSession(request.id);
    if (!context.mounted) return;
    final updated = state.requestById(request.id);
    showMessage(
      context,
      trArgs(
        'Buổi học đã hoàn thành · {name} cũng đã gửi đánh giá.',
        {'name': partner.name},
      ),
    );
    if (updated != null) {
      await openReview(context, updated);
    }
  }
}
