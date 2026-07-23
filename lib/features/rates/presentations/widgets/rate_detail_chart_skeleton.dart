import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_detail_chart.dart';

/// Skeleton loading placeholder wrapping [RateDetailChart] with dummy points in [Skeletonizer].
class RateDetailChartSkeleton extends StatelessWidget {
  const RateDetailChartSkeleton({super.key});

  static final List<HistoricalRatePoint> _dummyPoints = [
    HistoricalRatePoint(date: DateTime.now().subtract(const Duration(days: 6)), rate: 48.60),
    HistoricalRatePoint(date: DateTime.now().subtract(const Duration(days: 5)), rate: 48.62),
    HistoricalRatePoint(date: DateTime.now().subtract(const Duration(days: 4)), rate: 48.60),
    HistoricalRatePoint(date: DateTime.now().subtract(const Duration(days: 3)), rate: 48.63),
    HistoricalRatePoint(date: DateTime.now().subtract(const Duration(days: 2)), rate: 48.61),
    HistoricalRatePoint(date: DateTime.now().subtract(const Duration(days: 1)), rate: 48.60),
    HistoricalRatePoint(date: DateTime.now(), rate: 49.50),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: RateDetailChart(
        points: _dummyPoints,
        isSkeleton: true,
      ),
    );
  }
}
