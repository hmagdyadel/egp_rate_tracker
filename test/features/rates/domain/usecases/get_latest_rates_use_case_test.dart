import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/rates_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_latest_rates_use_case.dart';

class MockRatesRepository extends Mock implements RatesRepository {}

void main() {
  late GetLatestRatesUseCase useCase;
  late MockRatesRepository mockRepository;

  setUp(() {
    mockRepository = MockRatesRepository();
    useCase = GetLatestRatesUseCase(mockRepository);
  });

  test('GetLatestRatesUseCase delegates to repository.getLatestRates', () async {
    const tResult = ApiResult.success(RatesResult(rates: [], isFromCache: false));
    when(() => mockRepository.getLatestRates()).thenAnswer((_) async => tResult);

    final result = await useCase();

    expect(result, equals(tResult));
    verify(() => mockRepository.getLatestRates()).called(1);
  });
}
