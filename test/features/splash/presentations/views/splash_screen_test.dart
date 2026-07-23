import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:egp_rate_tracker/core/router/routes.dart';
import 'package:egp_rate_tracker/features/splash/presentations/views/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders title and subtitle correctly and navigates', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: Routes.splash,
        routes: {
          Routes.splash: (_) => const SplashScreen(),
          Routes.ratesList: (_) => const Scaffold(body: Text('Rates List')),
        },
      ),
    );

    expect(find.text('EGP Rate Tracker'), findsOneWidget);
    expect(find.text('Live Exchange Rates & Multi-Range Trends'), findsOneWidget);

    // Drain navigation timer and verify navigation
    await tester.pumpAndSettle(const Duration(milliseconds: 2000));
    expect(find.text('Rates List'), findsOneWidget);
  });
}
