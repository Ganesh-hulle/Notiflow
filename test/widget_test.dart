import 'package:flutter_test/flutter_test.dart';
import 'package:notiflow/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NotiFlowApp());

    // Verify that we are at the login screen (checks for "NotiFlow" text)
    expect(find.text('NotiFlow'), findsOneWidget);
  });
}
