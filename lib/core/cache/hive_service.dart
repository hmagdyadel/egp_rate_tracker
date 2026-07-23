import 'package:hive_flutter/hive_flutter.dart';

/// Thin wrapper around Hive for typed key-value cache operations.
///
/// Provides a simple API for saving and reading cached data.
/// All Hive operations are funnelled through this service so the
/// rest of the app never touches Hive directly.
class HiveService {
  HiveService._();

  static const String _ratesBoxName = 'rates_cache';

  static HiveService? _instance;

  /// The singleton instance — initialized via [init].
  static HiveService get instance {
    if (_instance == null) {
      throw StateError('HiveService not initialized. Call HiveService.init() first.');
    }
    return _instance!;
  }

  late Box<dynamic> _ratesBox;

  /// Initializes Hive and opens the required boxes.
  /// Call once during app bootstrap.
  static Future<HiveService> init() async {
    await Hive.initFlutter();
    final service = HiveService._();
    service._ratesBox = await Hive.openBox<dynamic>(_ratesBoxName);
    _instance = service;
    return service;
  }

  /// Saves a value under [key] in the rates cache box.
  Future<void> put(String key, dynamic value) async {
    await _ratesBox.put(key, value);
  }

  /// Reads a value by [key] from the rates cache box.
  /// Returns `null` if the key doesn't exist.
  T? get<T>(String key) {
    return _ratesBox.get(key) as T?;
  }

  /// Whether the cache contains a value for [key].
  bool containsKey(String key) => _ratesBox.containsKey(key);

  /// Clears all cached data.
  Future<void> clear() async {
    await _ratesBox.clear();
  }
}
