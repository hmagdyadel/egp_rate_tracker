import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:egp_rate_tracker/core/theme/app_colors.dart';
import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/theme/app_text_styles.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/chart_range.dart';

/// Soft-tinted pill Segmented Control for switching historical chart date ranges.
///
/// Follows the visual language of [RateChangeBadge]: solid soft background,
/// clean contrast colors, no glassmorphism or blur effects.
class ChartRangeSelector extends StatelessWidget {
  const ChartRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
  });

  final ChartRange selectedRange;
  final ValueChanged<ChartRange> onRangeSelected;

  static String _rangeLabel(ChartRange range) {
    switch (range) {
      case ChartRange.sevenDays:
        final t = 'range_7d'.tr();
        return t != 'range_7d' ? t : '7D';
      case ChartRange.oneMonth:
        final t = 'range_1m'.tr();
        return t != 'range_1m' ? t : '1M';
      case ChartRange.sixMonths:
        final t = 'range_6m'.tr();
        return t != 'range_6m' ? t : '6M';
      case ChartRange.oneYear:
        final t = 'range_1y'.tr();
        return t != 'range_1y' ? t : '1Y';
      case ChartRange.max:
        final t = 'range_max'.tr();
        return t != 'range_max' ? t : 'Max';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.surfaceDark
        : AppColors.dividerLight.withValues(alpha: 0.4);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.badgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: ChartRange.values.map((range) {
          final isSelected = range == selectedRange;

          final activeBg = isDark ? AppColors.primaryDark : AppColors.primary;
          const activeTextColor = Colors.white;
          final inactiveTextColor =
              isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onRangeSelected(range),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isSelected ? activeBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.badgeRadius - 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  _rangeLabel(range),
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected ? activeTextColor : inactiveTextColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
