import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pulse/main.dart';

void main() {
  testWidgets('Pulse app launches and shows the list screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PulseApp()));
    await tester.pump();

    expect(find.text('Pulse'), findsOneWidget);
    expect(find.text('Total spent'), findsOneWidget);
  });
}
