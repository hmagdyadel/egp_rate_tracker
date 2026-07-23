import 'package:intl/intl.dart';

/// API URL constants for the currency-api.pages.dev service.
///
/// The historical endpoint is unusual: the *date* is part of the hostname
/// (e.g. `2026-07-22.currency-api.pages.dev`), not a path segment. This means
/// we can't use a single fixed Dio baseUrl — we need to build the base URL
/// per-call for historical requests.
class ApiConstants {
  ApiConstants._();

  // ── Latest rates ──────────────────────────────────────────────────────
  static const String latestBaseUrl =
      'https://latest.currency-api.pages.dev/v1/currencies/';

  // ── Historical rates ──────────────────────────────────────────────────
  /// Builds the base URL for a specific historical date.
  /// Example: `https://2026-07-22.currency-api.pages.dev/v1/currencies/`
  static String historicalBaseUrl(DateTime date) {
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    return 'https://$formatted.currency-api.pages.dev/v1/currencies/';
  }

  // ── Shared endpoint path ──────────────────────────────────────────────
  /// The endpoint path appended to the base URL. Base currency is always EGP.
  static const String egpEndpoint = 'egp.json';
}
