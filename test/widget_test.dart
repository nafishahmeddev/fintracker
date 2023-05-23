import 'package:flutter_test/flutter_test.dart';
import 'package:fintracker/main.dart';

void main() {
  testWidgets('Main app startup test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
  });
}
