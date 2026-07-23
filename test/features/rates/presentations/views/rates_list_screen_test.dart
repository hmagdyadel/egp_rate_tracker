import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/widgets/empty_view.dart';
import 'package:egp_rate_tracker/core/widgets/error_view.dart';
import 'package:egp_rate_tracker/core/widgets/skeleton_loading.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_state.dart';
import 'package:egp_rate_tracker/features/rates/presentations/views/rates_list_screen.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_list_item.dart';

import 'package:intl/date_symbol_data_local.dart';

class MockRatesCubit extends MockCubit<RatesState> implements RatesCubit {}

void main() {
  late MockRatesCubit mockRatesCubit;

  final tRate = CurrencyRate(
    code: 'USD',
    name: 'US Dollar',
    rate: 50.0,
    changeAbsolute: 0.5,
    changePercent: 1.0,
    lastUpdated: DateTime(2026, 7, 23),
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting();
  });

  setUp(() {
    mockRatesCubit = MockRatesCubit();
  });

  Widget buildTestableWidget(RatesState state) {
    when(() => mockRatesCubit.state).thenReturn(state);
    when(() => mockRatesCubit.stream).thenAnswer((_) => Stream.value(state));

    return MaterialApp(
      home: BlocProvider<RatesCubit>.value(
        value: mockRatesCubit,
        child: const RatesListScreen(),
      ),
    );
  }

  group('RatesListScreen Widget Tests', () {
    testWidgets('renders RatesListSkeleton when state is loading', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const RatesState.loading()));

      expect(find.byType(RatesListSkeleton), findsOneWidget);
    });

    testWidgets('renders RateListItem list when state is success', (tester) async {
      await tester.pumpWidget(buildTestableWidget(RatesState.success(rates: [tRate], isFromCache: false)));

      expect(find.byType(RateListItem), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);
      expect(find.text('50.00'), findsOneWidget);
    });

    testWidgets('renders ErrorView when state is error', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const RatesState.error('Network failure')));

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Network failure'), findsOneWidget);
    });

    testWidgets('renders EmptyView when state is empty', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const RatesState.empty()));

      expect(find.byType(EmptyView), findsOneWidget);
    });
  });
}
