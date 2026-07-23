import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:egp_rate_tracker/core/cache/hive_service.dart';
import 'package:egp_rate_tracker/core/error/exception_mapper.dart';
import 'package:egp_rate_tracker/core/networking/api_constants.dart';
import 'package:egp_rate_tracker/core/networking/api_service.dart';
import 'package:egp_rate_tracker/core/networking/dio_factory.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_local_data_source.dart';
import 'package:egp_rate_tracker/features/rates/data/datasources/rates_remote_data_source.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_mapper.dart';
import 'package:egp_rate_tracker/features/rates/data/repositories/rates_repository_impl.dart';
import 'package:egp_rate_tracker/features/rates/domain/repositories/rates_repository.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_cached_rates_use_case.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_historical_rates_use_case.dart';
import 'package:egp_rate_tracker/features/rates/domain/usecases/get_latest_rates_use_case.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_cubit.dart';

final getIt = GetIt.instance;

/// Registers all dependencies into the service locator.
///
/// Called during [bootstrap] before the app starts.
/// Registration order: core → data sources → repositories → use cases.
Future<void> setupGetIt() async {
  // ── Core ──────────────────────────────────────────────────────────────
  final hiveService = await HiveService.init();
  getIt.registerSingleton<HiveService>(hiveService);

  getIt.registerSingleton<ExceptionMapper>(const ExceptionMapper());
  getIt.registerSingleton<RatesMapper>(const RatesMapper());

  // ── Networking ────────────────────────────────────────────────────────
  final latestDio = DioFactory.createLatestDio(ApiConstants.latestBaseUrl);
  getIt.registerSingleton<Dio>(latestDio);

  final apiService = ApiService(latestDio);
  getIt.registerSingleton<ApiService>(apiService);

  // ── Data sources ──────────────────────────────────────────────────────
  getIt.registerSingleton<RatesRemoteDataSource>(
    RatesRemoteDataSource(latestApiService: getIt<ApiService>()),
  );

  getIt.registerSingleton<RatesLocalDataSource>(
    RatesLocalDataSource(hiveService: getIt<HiveService>()),
  );

  // ── Repository ────────────────────────────────────────────────────────
  getIt.registerSingleton<RatesRepository>(
    RatesRepositoryImpl(
      remote: getIt<RatesRemoteDataSource>(),
      local: getIt<RatesLocalDataSource>(),
      mapper: getIt<RatesMapper>(),
      exceptionMapper: getIt<ExceptionMapper>(),
    ),
  );

  // ── Use cases ─────────────────────────────────────────────────────────
  getIt.registerSingleton<GetLatestRatesUseCase>(
    GetLatestRatesUseCase(getIt<RatesRepository>()),
  );

  getIt.registerSingleton<GetHistoricalRatesUseCase>(
    GetHistoricalRatesUseCase(getIt<RatesRepository>()),
  );

  getIt.registerSingleton<GetCachedRatesUseCase>(
    GetCachedRatesUseCase(getIt<RatesRepository>()),
  );

  // ── Cubits ────────────────────────────────────────────────────────────
  getIt.registerFactory<RatesCubit>(
    () => RatesCubit(getLatestRatesUseCase: getIt<GetLatestRatesUseCase>()),
  );

  getIt.registerFactory<DetailCubit>(
    () => DetailCubit(getHistoricalRatesUseCase: getIt<GetHistoricalRatesUseCase>()),
  );
}
