import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

/// Retrofit service interface for the currency-api.pages.dev endpoints.
///
/// Both latest and historical endpoints share the same path (`egp.json`).
/// The difference is the Dio instance's base URL:
/// - Latest: `https://latest.currency-api.pages.dev/v1/currencies/`
/// - Historical: `https://{date}.currency-api.pages.dev/v1/currencies/`
///
/// Use [DioFactory] to create the appropriate Dio instance for each case.
///
/// Returns raw JSON as a `Map<String, dynamic>`. We avoid typed model return
/// here because the response shape (`{ "date": "...", "egp": { ... } }`) is
/// simple enough to map manually in the data layer, and Retrofit's code-gen
/// struggles with `Map<String, dynamic>` as a generic return type.
@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  /// Fetches rates for EGP against all supported currencies.
  ///
  /// Works for both latest and historical — the Dio base URL determines which.
  /// Returns the raw JSON map: `{ "date": "...", "egp": { "usd": ..., ... } }`
  @GET('egp.json')
  Future<dynamic> getRates();
}
