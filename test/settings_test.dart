import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap_campus/l10n/app_text.dart';
import 'package:skillswap_campus/main.dart';
import 'package:skillswap_campus/screens/settings_screen.dart';
import 'package:skillswap_campus/state/app_scope.dart';
import 'package:skillswap_campus/theme/app_theme.dart';

Future<void> _openSettings(WidgetTester tester) async {
  await tester.pumpWidget(const SkillSwapApp());
  await tester.tap(find.text('Vào bằng tài khoản demo'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Hồ sơ'));
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.settings_outlined));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Mặc định dùng tiếng Việt và giao diện sáng', (tester) async {
    await tester.pumpWidget(const SkillSwapApp());

    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(AppText.language, 'vi');
    expect(AppColors.palette, AppPalette.light);
  });

  testWidgets('Khởi động với tiếng Anh hiển thị đúng bản dịch', (tester) async {
    await tester.pumpWidget(const SkillSwapApp(initialLanguage: 'en'));

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsNothing);
    expect(AppText.language, 'en');
  });

  testWidgets('Đổi ngôn ngữ trong Cài đặt cập nhật toàn bộ giao diện',
      (tester) async {
    await _openSettings(tester);

    expect(find.text('Cài đặt'), findsWidgets);
    expect(find.text('Ngôn ngữ'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(AppText.language, 'en');
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Cài đặt'), findsNothing);
  });

  testWidgets('Đổi giao diện tối áp dụng cho MaterialApp và bảng màu',
      (tester) async {
    await _openSettings(tester);

    await tester.tap(find.text('Tối'));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final settingsContext = tester.element(find.byType(SettingsScreen));
    final state = AppScope.of(settingsContext);

    expect(app.themeMode, ThemeMode.dark);
    expect(state.isDark, isTrue);
    expect(AppColors.palette, AppPalette.dark);
    expect(AppColors.background, AppPalette.dark.background);
  });

  testWidgets('Màn Nhóm 12 hiển thị đủ thành viên và tỷ lệ đóng góp',
      (tester) async {
    await _openSettings(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nhóm phát triển'));
    await tester.pumpAndSettle();

    expect(find.text('Hoàng Quốc Khánh'), findsOneWidget);
    expect(find.text('Nhóm trưởng'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.text('Đặng Tuấn Ngọc'), findsOneWidget);
    expect(find.text('35%'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Lê Quốc Anh'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Đinh Trung Kiên'), findsOneWidget);
    expect(find.text('Lê Quốc Anh'), findsOneWidget);
    expect(find.text('15%'), findsOneWidget);
    expect(find.text('10%'), findsOneWidget);
  });
}
