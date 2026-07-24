import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_list_item.dart';

/// Skeleton loading list wrapping actual [RateListItem] layouts with [Skeletonizer].
class RatesListSkeleton extends StatelessWidget {
  const RatesListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  static final List<CurrencyRate> _dummyRates = [
    CurrencyRate(
      code: 'USD',
      name: 'United States Dollar',
      rate: 49.50,
      changeAbsolute: 0.15,
      changePercent: 0.30,
      lastUpdated: DateTime.now(),
    ),
    CurrencyRate(
      code: 'EUR',
      name: 'Euro',
      rate: 53.20,
      changeAbsolute: -0.10,
      changePercent: -0.18,
      lastUpdated: DateTime.now(),
    ),
    CurrencyRate(
      code: 'GBP',
      name: 'British Pound',
      rate: 62.80,
      changeAbsolute: 0.25,
      changePercent: 0.40,
      lastUpdated: DateTime.now(),
    ),
    CurrencyRate(
      code: 'SAR',
      name: 'Saudi Riyal',
      rate: 13.18,
      changeAbsolute: 0.00,
      changePercent: 0.00,
      lastUpdated: DateTime.now(),
    ),
    CurrencyRate(
      code: 'JPY',
      name: 'Japanese Yen',
      rate: 0.32,
      changeAbsolute: -0.01,
      changePercent: -0.03,
      lastUpdated: DateTime.now(),
    ),
  ];

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
            index: index,
            onTap: () {},
          );
        },
      ),
    );
  }
}
