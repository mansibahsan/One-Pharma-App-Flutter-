import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_pharma/main.dart';

void main() {
  testWidgets('OnePharma app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OnePharmaApp(),
      ),
    );
    expect(find.byType(OnePharmaApp), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
