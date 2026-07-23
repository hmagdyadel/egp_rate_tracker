import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:egp_rate_tracker/core/di/dependency_injection.dart';
import 'package:egp_rate_tracker/core/router/routes.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/views/rate_detail_screen.dart';
import 'package:egp_rate_tracker/features/rates/presentations/views/rates_list_screen.dart';
import 'package:egp_rate_tracker/features/splash/presentations/views/splash_screen.dart';

/// Handles named-route generation for the app.
///
/// Routes:
/// - [Routes.splash] — initial animated branding screen
/// - [Routes.ratesList] — the main currency list screen
/// - [Routes.rateDetail] — the detail + chart screen for a single currency
class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case Routes.ratesList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<RatesCubit>()..fetchRates(),
            child: const RatesListScreen(),
          ),
        );

      case Routes.rateDetail:
        final rate = settings.arguments as CurrencyRate?;
        if (rate == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid rate argument')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<DetailCubit>()..fetchHistoricalRates(rate.code),
            child: RateDetailScreen(rate: rate),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
