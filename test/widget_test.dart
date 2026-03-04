import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cat_tinder/presentation/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('Onboarding renders key steps', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: OnboardingScreen(onCompleted: () async {}),
      ),
    );

    expect(find.text('Свайпы и лайки'), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
  });
}
