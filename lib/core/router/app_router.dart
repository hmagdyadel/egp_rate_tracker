import 'package:flutter/material.dart';

import 'routes.dart';

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
          builder: (_) => const _PlaceholderScreen(title: 'Rates List'),
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

/// Temporary placeholder — replaced in Phase 4/5 with real screens.
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
