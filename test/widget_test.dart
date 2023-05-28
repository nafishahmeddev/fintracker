import 'package:fintracker/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Main app startup test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
  });
}
