import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/theme/app_text_styles.dart';
import 'package:egp_rate_tracker/core/widgets/error_view.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/historical_rate_point.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_state.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_change_badge.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_detail_chart.dart';

/// Screen showing exchange rate details and 7-day trend chart for a currency.
class RateDetailScreen extends StatelessWidget {
  const RateDetailScreen({
    super.key,
    required this.rate,
  });

  final CurrencyRate rate;

  /// Dummy 7-day points for Skeletonizer loading state.
  static final List<HistoricalRatePoint> _dummyPoints = List.generate(
    7,
    (index) => HistoricalRatePoint(
      date: DateTime.now().subtract(Duration(days: 6 - index)),
      rate: 49.0 + (index * 0.1),
    ),
  );

  /// Returns localized currency name using easy_localization keys.
  static String _localizedName(String code, String defaultName) {
    final key = 'currency_${code.toLowerCase()}';
    final translated = key.tr();
    return translated != key ? translated : defaultName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final localizedName = _localizedName(rate.code, rate.name);
    final formattedRate = rate.rate.toStringAsFixed(2);
    final formattedDate = DateFormat.yMMMd(context.locale.languageCode).format(rate.lastUpdated);

    return Scaffold(
      appBar: AppBar(
        title: Text('rate_detail_title'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Rate Header Card ──────────────────────────────────────────────
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rate.code,
                              style: AppTextStyles.headline.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              localizedName,
                              style: AppTextStyles.body.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        RateChangeBadge(
                          changeAbsolute: rate.changeAbsolute,
                          changePercent: rate.changePercent,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      formattedRate,
                      style: AppTextStyles.rateDisplay.copyWith(
                        fontSize: 36,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'last_updated'.tr(args: [formattedDate]),
                      style: AppTextStyles.caption.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ── 7-Day Trend Chart Card ─────────────────────────────────────────
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'historical_chart_title'.tr(),
                      style: AppTextStyles.title.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    BlocBuilder<DetailCubit, DetailState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => Skeletonizer(
                            enabled: true,
                            child: RateDetailChart(
                              points: _dummyPoints,
                              isPositiveChange: rate.isPositiveChange,
                              isNegativeChange: rate.isNegativeChange,
                            ),
                          ),
                          loading: () => Skeletonizer(
                            enabled: true,
                            child: RateDetailChart(
                              points: _dummyPoints,
                              isPositiveChange: rate.isPositiveChange,
                              isNegativeChange: rate.isNegativeChange,
                            ),
                          ),
                          error: (message) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                            child: ErrorView(
                              message: message,
                              onRetry: () {
                                context.read<DetailCubit>().fetchHistoricalRates(rate.code);
                              },
                            ),
                          ),
                          success: (points) {
                            return RateDetailChart(
                              points: points,
                              isPositiveChange: rate.isPositiveChange,
                              isNegativeChange: rate.isNegativeChange,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
