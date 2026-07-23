import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

/// Registers all dependencies into the service locator.
///
/// Called during [bootstrap] before the app starts.
/// Registrations will be added layer-by-layer as each phase lands:
/// - Phase 3: data sources, repositories, use cases, cubits
Future<void> setupGetIt() async {
  // TODO(phase-3): Register Dio, ApiService, data sources, repos, use cases.
}
