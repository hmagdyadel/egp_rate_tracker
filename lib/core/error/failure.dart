/// Base failure type and concrete subtypes for typed error handling.
///
/// Every failure carries a user-facing friendly [message] for UI display
/// and an optional [technicalDetails] string for developer logging.
sealed class Failure {
  const Failure(this.message, [this.technicalDetails]);

  /// Friendly human-readable message intended for end users (ErrorView display).
  final String message;

  /// Optional raw exception message or technical details for developer logging.
  final String? technicalDetails;

  @override
  String toString() => technicalDetails != null
      ? '$runtimeType: $message (Details: $technicalDetails)'
      : '$runtimeType: $message';
}

/// A network-level error (timeout, DNS failure, connection reset, etc.).
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Unable to connect. Please try again.',
    super.technicalDetails,
  ]);
}

/// The server returned an error response (non-2xx status code).
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Server error. Please try again later.',
    super.technicalDetails,
  ]);
}

/// Failed to read from or write to the local cache.
class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Unable to load cached data.',
    super.technicalDetails,
  ]);
}

/// The device has no internet connectivity.
class NoInternetFailure extends Failure {
  const NoInternetFailure([
    super.message = 'No internet connection. Please check your network.',
    super.technicalDetails,
  ]);
}
