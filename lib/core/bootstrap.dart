import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/dependency_injection.dart';
import 'observer/custom_bloc_observer.dart';

/// Performs all async initialization before [runApp].
///
/// Call order:
/// 1. Flutter binding
/// 2. EasyLocalization
/// 3. Service locator (get_it)
/// 4. Bloc observer
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupGetIt();
  Bloc.observer = CustomBlocObserver();
}
