import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:egp_rate_tracker/core/di/dependency_injection.dart';
import 'package:egp_rate_tracker/core/router/routes.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/views/rates_list_screen.dart';

/// Handles named-route generation for the app.
///
/// Two routes:
/// - [Routes.ratesList] — the main currency list screen
/// - [Routes.rateDetail] — the detail + chart screen for a single currency
class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.ratesList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<RatesCubit>()..fetchRates(),
            child: const RatesListScreen(),
          ),
        );

      case Routes.rateDetail:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Rate Detail'),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(title: 'Not Found'),
        );
    }
  }
}

/// Temporary placeholder — replaced in Phase 5 with real detail screen.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
