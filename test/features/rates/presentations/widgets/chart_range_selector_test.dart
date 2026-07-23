import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:egp_rate_tracker/features/rates/domain/entities/chart_range.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/chart_range_selector.dart';

void main() {
  Widget buildWidget({
    ChartRange selectedRange = ChartRange.sevenDays,
    required ValueChanged<ChartRange> onRangeSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ChartRangeSelector(
          selectedRange: selectedRange,
          onRangeSelected: onRangeSelected,
        ),
      ),
    );
  }

  testWidgets('renders all 5 range labels (7D, 1M, 6M, 1Y, Max)', (tester) async {
    await tester.pumpWidget(buildWidget(onRangeSelected: (_) {}));

    expect(find.text('7D'), findsOneWidget);
    expect(find.text('1M'), findsOneWidget);
    expect(find.text('6M'), findsOneWidget);
    expect(find.text('1Y'), findsOneWidget);
    expect(find.text('Max'), findsOneWidget);
  });

  testWidgets('tapping a range tab invokes onRangeSelected callback with correct ChartRange', (tester) async {
    ChartRange? selected;
    await tester.pumpWidget(buildWidget(onRangeSelected: (range) {
      selected = range;
    }));

    await tester.tap(find.text('1M'));
    expect(selected, equals(ChartRange.oneMonth));

    await tester.tap(find.text('Max'));
    expect(selected, equals(ChartRange.max));
  });
}
