import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/bootstrap.dart';
import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  await bootstrap();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: EgpRateTrackerApp(appRouter: AppRouter()),
    ),
  );
}

class EgpRateTrackerApp extends StatelessWidget {
  const EgpRateTrackerApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EGP Rate Tracker',
      // Localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // Routing
      initialRoute: Routes.ratesList,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
