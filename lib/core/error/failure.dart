/// Base failure type and concrete subtypes for typed error handling.
///
/// Every failure carries a human-readable [message] for UI display.
/// The subtypes map 1:1 to the error categories the app can encounter:
/// network, server, cache, and no-internet.
sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// A network-level error (timeout, DNS failure, connection reset, etc.).
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// The server returned an error response (non-2xx status code).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Failed to read from or write to the local cache.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// The device has no internet connectivity.
class NoInternetFailure extends Failure {
  const NoInternetFailure([super.message = 'No internet connection']);
}
