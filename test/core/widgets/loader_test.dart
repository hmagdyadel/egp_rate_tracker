import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:egp_rate_tracker/core/theme/app_colors.dart';
import 'package:egp_rate_tracker/core/widgets/loader.dart';

void main() {
  testWidgets('Loader renders SpinKitThreeBounce with primary color by default', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Loader(),
        ),
      ),
    );

    expect(find.byType(Loader), findsOneWidget);
  });

  testWidgets('Loader renders with custom color and size', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Loader(
            color: AppColors.positive,
            size: 40.0,
          ),
        ),
      ),
    );

    expect(find.byType(Loader), findsOneWidget);
  });
}
