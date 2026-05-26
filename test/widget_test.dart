import 'package:flutter_test/flutter_test.dart';
import 'package:ud_ban_hang_onl/main.dart';
import 'package:ud_ban_hang_onl/screens/login_screen.dart';

void main() {
  testWidgets('Kiểm tra màn hình đăng nhập', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
