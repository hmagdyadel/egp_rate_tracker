import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/features/rates/domain/entities/chart_range.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_state.dart';
import 'package:egp_rate_tracker/features/rates/presentations/views/rate_detail_screen.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_detail_chart.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_detail_chart_skeleton.dart';

class MockDetailCubit extends MockCubit<DetailState> implements DetailCubit {}

void main() {
  late MockDetailCubit mockDetailCubit;

  final tRate = CurrencyRate(
    code: 'USD',
    name: 'US Dollar',
    rate: 50.0,
    changeAbsolute: 0.5,
    changePercent: 1.0,
    lastUpdated: DateTime(2026, 7, 23),
  );

  final tPoints7D = List.generate(
    7,
    (i) => HistoricalRatePoint(
      date: DateTime(2026, 7, 17 + i),
      rate: 49.0 + i * 0.1,
    ),
  );

  final tPoints1M = List.generate(
    30,
    (i) => HistoricalRatePoint(
      date: DateTime(2026, 6, 24).add(Duration(days: i)),
      rate: 48.0 + i * 0.05,
    ),
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
    registerFallbackValue(ChartRange.sevenDays);
  });

  setUp(() {
    mockDetailCubit = MockDetailCubit();
  });

  group('RateDetailScreen Widget Tests', () {
    testWidgets('tapping range tab calls fetchHistoricalRates with selected range', (tester) async {
      final initialState = DetailState.success(tPoints7D, selectedRange: ChartRange.sevenDays);
      when(() => mockDetailCubit.state).thenReturn(initialState);
      when(() => mockDetailCubit.stream).thenAnswer((_) => Stream.value(initialState));
      when(() => mockDetailCubit.fetchHistoricalRates('USD', range: any(named: 'range')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<DetailCubit>.value(
          value: mockDetailCubit,
          child: RateDetailScreen(rate: tRate),
        ),
      ));

      // Tap 1M tab
      await tester.tap(find.text('1M'));
      await tester.pump();

      verify(() => mockDetailCubit.fetchHistoricalRates('USD', range: ChartRange.oneMonth)).called(1);
    });

    testWidgets('renders RateDetailChart with new points when state updates to 1M success', (tester) async {
      final streamController = StreamController<DetailState>.broadcast();
      final initialState = DetailState.success(tPoints7D, selectedRange: ChartRange.sevenDays);
      final newState = DetailState.success(tPoints1M, selectedRange: ChartRange.oneMonth);

      when(() => mockDetailCubit.state).thenReturn(initialState);
      when(() => mockDetailCubit.stream).thenAnswer((_) => streamController.stream);

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<DetailCubit>.value(
          value: mockDetailCubit,
          child: RateDetailScreen(rate: tRate),
        ),
      ));

      final initialChart = tester.widget<RateDetailChart>(find.byType(RateDetailChart));
      expect(initialChart.points.length, equals(7));

      // Emit newState onto the stream
      when(() => mockDetailCubit.state).thenReturn(newState);
      streamController.add(newState);
      await tester.pumpAndSettle();

      final updatedChart = tester.widget<RateDetailChart>(find.byType(RateDetailChart));
      expect(updatedChart.points.length, equals(30));

      await streamController.close();
    });

    testWidgets('renders RateDetailChartSkeleton placeholder when state is loading', (tester) async {
      const loadingState = DetailState.loading(selectedRange: ChartRange.oneMonth);
      when(() => mockDetailCubit.state).thenReturn(loadingState);
      when(() => mockDetailCubit.stream).thenAnswer((_) => Stream.value(loadingState));

      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<DetailCubit>.value(
          value: mockDetailCubit,
          child: RateDetailScreen(rate: tRate),
        ),
      ));

      expect(find.byType(RateDetailChartSkeleton), findsOneWidget);
    });
  });
}
