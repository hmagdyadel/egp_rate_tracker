import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_list_item.dart';

/// Skeleton loading list wrapping actual [RateListItem] layouts with [Skeletonizer].
class RatesListSkeleton extends StatelessWidget {
  const RatesListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  static final List<CurrencyRate> _dummyRates = List.generate(
    5,
    (index) => CurrencyRate(
      code: 'USD',
      name: 'United States Dollar',
      rate: 49.50,
      changeAbsolute: 0.15,
      changePercent: 0.30,
      lastUpdated: DateTime.now(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final dummyRate = _dummyRates[index % _dummyRates.length];
          return RateListItem(
            rate: dummyRate,
            onTap: () {},
          );
        },
      ),
    );
  }
}
