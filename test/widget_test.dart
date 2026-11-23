import 'package:flutter_test/flutter_test.dart';
import 'package:sintaks_app/main.dart';

void main() {
  testWidgets('App loads AuthPage smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SintaksApp());
    expect(find.text('SINTAKS'), findsOneWidget);
  });
}
