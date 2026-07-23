import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_historical_rates_use_case.dart';

class MockRatesRepository extends Mock implements RatesRepository {}

void main() {
  late GetHistoricalRatesUseCase useCase;
  late MockRatesRepository mockRepository;

  setUp(() {
    mockRepository = MockRatesRepository();
    useCase = GetHistoricalRatesUseCase(mockRepository);
  });

  test('GetHistoricalRatesUseCase delegates to repository.getHistoricalRates', () async {
    final dates = [DateTime.now()];
    const tResult = ApiResult<List<Never>>.success([]);
    when(() => mockRepository.getHistoricalRates(dates: dates, currencyCode: 'usd'))
        .thenAnswer((_) async => tResult);

    final result = await useCase(dates: dates, currencyCode: 'usd');

    expect(result, equals(tResult));
    verify(() => mockRepository.getHistoricalRates(dates: dates, currencyCode: 'usd')).called(1);
  });
}
