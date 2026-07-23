import 'package:egp_rate_tracker/core/error/failure.dart';

export 'package:egp_rate_tracker/core/error/failure.dart';

/// Unified result wrapper for all API / repository operations.
///
/// Provides a `when` callback API for exhaustive handling at call sites,
/// matching the pattern used throughout the app (data source → repository →
/// use case → cubit).
///
/// ```dart
/// final result = await repository.getLatestRates();
/// result.when(
///   success: (data) => emit(state.copyWith(rates: data)),
///   failure: (failure) => emit(state.copyWith(error: failure.message)),
/// );
/// ```
sealed class ApiResult<T> {
  const ApiResult._();

  const factory ApiResult.success(T data) = ApiSuccess<T>;
  const factory ApiResult.failure(Failure failure) = ApiFailure<T>;

  /// Exhaustive fold — forces call sites to handle both cases.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data) => success(data),
      ApiFailure<T>(:final failure) => onFailure(failure),
    };
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data) : super._();
  final T data;
}

class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.failure) : super._();
  final Failure failure;
}
