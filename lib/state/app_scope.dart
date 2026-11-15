import 'package:flutter/widgets.dart';

import 'app_state.dart';
import '../l10n/app_text.dart';

/// Cho phép mọi màn hình truy cập [AppState] và tự rebuild khi dữ liệu đổi.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, tr('Không tìm thấy AppScope trong widget tree'));
    return scope!.notifier!;
  }

  /// Đọc state mà không đăng ký rebuild (dùng trong callback).
  static AppState read(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, tr('Không tìm thấy AppScope trong widget tree'));
    return scope!.notifier!;
  }
}
