import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_detail_chart.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_detail_chart_skeleton.dart';

void main() {
  testWidgets('RateDetailChartSkeleton renders RateDetailChart with isSkeleton true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RateDetailChartSkeleton(),
        ),
      ),
    );

    expect(find.byType(RateDetailChartSkeleton), findsOneWidget);
    final chartWidget = tester.widget<RateDetailChart>(find.byType(RateDetailChart));
    expect(chartWidget.isSkeleton, isTrue);
    expect(chartWidget.points.length, equals(7));
  });
}
