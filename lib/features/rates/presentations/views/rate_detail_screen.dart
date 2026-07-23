import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:egp_rate_tracker/core/theme/app_card_decoration.dart';
import 'package:egp_rate_tracker/core/theme/app_colors.dart';
import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/theme/app_text_styles.dart';
import 'package:egp_rate_tracker/core/widgets/error_view.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';

import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_cubit.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/detail_state.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/chart_range_selector.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_change_badge.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_detail_chart.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_detail_chart_skeleton.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_list_item.dart';

/// Screen showing exchange rate details and multi-range trend chart for a currency.
class RateDetailScreen extends StatelessWidget {
  const RateDetailScreen({
    super.key,
    required this.rate,
  });

  final CurrencyRate rate;

  /// Returns localized currency name using easy_localization keys.
  static String _localizedName(String code, String defaultName) {
    final key = 'currency_${code.toLowerCase()}';
    final translated = key.tr();
    return translated != key ? translated : defaultName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final monogram = RateListItem.currencyMonogram(rate.code);
    final localizedName = _localizedName(rate.code, rate.name);
    final formattedRate = rate.rate.toStringAsFixed(2);
    final formattedDate = DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(rate.lastUpdated);

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
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: appCardDecoration(context),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Monogram avatar + Code & Name + Change badge
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            monogram,
                            style: AppTextStyles.title.copyWith(
                              color: isDark ? AppColors.primaryLight : AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rate.code,
                                style: AppTextStyles.title.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                localizedName,
                                style: AppTextStyles.caption.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RateChangeBadge(
                          changeAbsolute: rate.changeAbsolute,
                          changePercent: rate.changePercent,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Dominant Rate Display
                    Text(
                      formattedRate,
                      style: AppTextStyles.rateDisplay.copyWith(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Last updated context
                    Text(
                      'last_updated'.tr(namedArgs: {'date': formattedDate}),
                      style: AppTextStyles.caption.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // ── Multi-Range Historical Chart Card ──────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: appCardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Selector Header with side padding
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      top: AppSpacing.lg,
                      bottom: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'historical_chart_title'.tr(),
                          style: AppTextStyles.title.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ),
                  ),

                  // Full-width chart body
                  BlocBuilder<DetailCubit, DetailState>(
                    builder: (context, state) {
                      final selectedRange = state.selectedRange;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            child: ChartRangeSelector(
                              selectedRange: selectedRange,
                              onRangeSelected: (newRange) {
                                if (newRange != selectedRange) {
                                  context.read<DetailCubit>().fetchHistoricalRates(
                                        rate.code,
                                        range: newRange,
                                      );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          state.when(
                            initial: (range) {
                              log('UI render: initial (range: $range)', name: 'RateDetailScreen');
                              return const RateDetailChartSkeleton();
                            },
                            loading: (range) {
                              log('UI render: loading (range: $range)', name: 'RateDetailScreen');
                              return const RateDetailChartSkeleton();
                            },
                            error: (message, range) {
                              log('UI render: error (range: $range, message: $message)', name: 'RateDetailScreen');
                              return Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: ErrorView(
                                  message: message,
                                  onRetry: () {
                                    context.read<DetailCubit>().fetchHistoricalRates(
                                          rate.code,
                                          range: range,
                                        );
                                  },
                                ),
                              );
                            },
                            success: (points, range) {
                              log('UI render: success (range: $range, points: ${points.length})', name: 'RateDetailScreen');
                              return RateDetailChart(
                                key: ValueKey(range),
                                points: points,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
