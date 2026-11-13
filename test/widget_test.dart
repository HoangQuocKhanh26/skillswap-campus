import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap_campus/main.dart';

void main() {
  testWidgets('Kiểm tra màn hình đăng nhập', (WidgetTester tester) async {
    await tester.pumpWidget(const SkillSwapApp());

    expect(find.text('SkillSwap Campus'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });

  testWidgets('Vào tài khoản demo hiển thị màn hình khám phá',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SkillSwapApp());

    await tester.tap(find.text('Vào bằng tài khoản demo'));
    await tester.pumpAndSettle();

    expect(find.text('Khám phá'), findsWidgets);
    expect(find.text('Yêu cầu'), findsOneWidget);
    expect(find.textContaining('Ngọc Anh'), findsWidgets);
  });
}
