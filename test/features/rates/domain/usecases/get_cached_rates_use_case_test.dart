import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:egp_rate_tracker/core/networking/api_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/rates_result.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_cached_rates_use_case.dart';

class MockRatesRepository extends Mock implements RatesRepository {}

void main() {
  late GetCachedRatesUseCase useCase;
  late MockRatesRepository mockRepository;

  setUp(() {
    mockRepository = MockRatesRepository();
    useCase = GetCachedRatesUseCase(mockRepository);
  });

  test('GetCachedRatesUseCase delegates to repository.getCachedRates', () async {
    const tResult = ApiResult.success(RatesResult(rates: [], isFromCache: true));
    when(() => mockRepository.getCachedRates()).thenAnswer((_) async => tResult);

    final result = await useCase();

    expect(result, equals(tResult));
    verify(() => mockRepository.getCachedRates()).called(1);
  });
}
