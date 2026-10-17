import 'package:flutter_test/flutter_test.dart';
import 'package:devcircle_ui/main.dart';

void main() {
  testWidgets('Topics tab starts empty', (tester) async {
    await tester.pumpWidget(const DevCircleApp());
    expect(find.text('No topics yet — start one!'), findsOneWidget);
  });

  testWidgets('Can add a topic from the + button', (tester) async {
    await tester.pumpWidget(const DevCircleApp());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Flutter-Tips');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Flutter-Tips'), findsOneWidget);
  });
}