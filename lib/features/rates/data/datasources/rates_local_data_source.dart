import 'dart:convert';

import 'package:egp_rate_tracker/core/cache/hive_service.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_response_model.dart';

/// Local cache for rates data, backed by [HiveService].
///
/// Stores the last-known rates as JSON strings plus a last-updated
/// timestamp, so the app can serve cached data when offline.
class RatesLocalDataSource {
  RatesLocalDataSource({required this._hiveService});

  final HiveService _hiveService;

  static const String _latestRatesKey = 'latest_rates';
  static const String _yesterdayRatesKey = 'yesterday_rates';
  static const String _lastUpdatedKey = 'last_updated';

  // ── Save ────────────────────────────────────────────────────────────

  /// Caches today's and yesterday's rate responses and records the timestamp.
  Future<void> cacheRates({
    required RatesResponseModel today,
    required RatesResponseModel yesterday,
  }) async {
    await Future.wait([
      _hiveService.put(_latestRatesKey, jsonEncode(today.toJson())),
      _hiveService.put(_yesterdayRatesKey, jsonEncode(yesterday.toJson())),
      _hiveService.put(_lastUpdatedKey, DateTime.now().toIso8601String()),
    ]);
  }

  // ── Read ────────────────────────────────────────────────────────────

  /// Returns the cached latest rates, or `null` if nothing is cached.
  RatesResponseModel? getCachedLatestRates() {
    final raw = _hiveService.get<String>(_latestRatesKey);
    if (raw == null) return null;
    return RatesResponseModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  /// Returns the cached yesterday rates, or `null` if nothing is cached.
  RatesResponseModel? getCachedYesterdayRates() {
    final raw = _hiveService.get<String>(_yesterdayRatesKey);
    if (raw == null) return null;
    return RatesResponseModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  /// Returns the last time the cache was updated, or `null` if never.
  DateTime? getLastUpdated() {
    final raw = _hiveService.get<String>(_lastUpdatedKey);
    if (raw == null) return null;
    return DateTime.parse(raw);
  }

  /// Whether valid cached data exists.
  bool get hasCachedData => _hiveService.containsKey(_latestRatesKey);
}
