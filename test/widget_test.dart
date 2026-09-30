import 'package:flutter_test/flutter_test.dart';
import 'package:devcircle_ui/main.dart';

void main() {
    testWidgets('Topics tab starts empty', (tester) async {
        await tester.pumpWidget(const DevCircleApp());
        expect(find.text('No topics yet - start one!'), findsOneWidget);
    })
}