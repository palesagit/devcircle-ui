import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devcircle_ui/main.dart';

void main() {
  // CHANGED: the app starts completely empty - no sample data.
  testWidgets('App starts empty', (tester) async {
    await tester.pumpWidget(const DevCircleApp());
    expect(find.text('DevCircle'), findsOneWidget);
    expect(find.text('No topics yet'), findsOneWidget);
    expect(find.text('No resources yet'), findsOneWidget);
    expect(find.text('No meetings scheduled'), findsOneWidget);
  });

  testWidgets('Can add a topic from the + button', (tester) async {
    await tester.pumpWidget(const DevCircleApp());
    await tester.tap(find.byKey(const Key('add-topic')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Flutter-Tips');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Flutter-Tips'), findsOneWidget);
    expect(find.text('No topics yet'), findsNothing);
  });
}
