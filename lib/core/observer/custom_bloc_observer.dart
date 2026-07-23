import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Lightweight observer that logs Bloc/Cubit lifecycle and state transitions.
///
/// Wired in [bootstrap] via `Bloc.observer = CustomBlocObserver()`.
/// Uses `dart:developer` [log] for clean DevTools output.
class CustomBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    log('onCreate: ${bloc.runtimeType}', name: 'Bloc');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log(
      'onChange: ${bloc.runtimeType} | '
      '${change.currentState.runtimeType} → ${change.nextState.runtimeType}',
      name: 'Bloc',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log(
      'onError: ${bloc.runtimeType} | $error',
      name: 'Bloc',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    log('onClose: ${bloc.runtimeType}', name: 'Bloc');
  }
}
