import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_change_badge.dart';

void main() {
  group('RateChangeBadge Widget Tests', () {
    testWidgets('renders ▲ glyph and + sign for positive rate increase (EGP weakening)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RateChangeBadge(
              changeAbsolute: 0.50,
              changePercent: 1.25,
            ),
          ),
        ),
      );

      expect(find.text('▲'), findsOneWidget);
      expect(find.text('+1.25%'), findsOneWidget);
    });

    testWidgets('renders ▼ glyph for negative rate decrease (EGP strengthening)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RateChangeBadge(
              changeAbsolute: -0.30,
              changePercent: -0.75,
            ),
          ),
        ),
      );

      expect(find.text('▼'), findsOneWidget);
      expect(find.text('0.75%'), findsOneWidget);
    });

    testWidgets('renders — em dash glyph for zero change (rate unchanged)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RateChangeBadge(
              changeAbsolute: 0.0,
              changePercent: 0.0,
            ),
          ),
        ),
      );

      expect(find.text('—'), findsOneWidget);
      expect(find.text('0.00%'), findsOneWidget);
    });
  });
}
