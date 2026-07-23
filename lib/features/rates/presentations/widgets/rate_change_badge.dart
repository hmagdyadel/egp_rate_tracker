import 'package:flutter/material.dart';

import 'package:egp_rate_tracker/core/theme/app_colors.dart';
import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/theme/app_text_styles.dart';

/// Soft-tinted pill badge displaying currency rate movement with ▲/▼ glyph.
///
/// **Color semantics for currency exchange rate**:
/// - `changeAbsolute > 0` (rate increased = EGP weakened): **RED** (`AppColors.negative`) + **▲**
/// - `changeAbsolute < 0` (rate decreased = EGP strengthened): **GREEN** (`AppColors.positive`) + **▼**
/// - `changeAbsolute == 0`: Neutral grey pill
class RateChangeBadge extends StatelessWidget {
  const RateChangeBadge({
    super.key,
    required this.changeAbsolute,
    required this.changePercent,
  });

  final double changeAbsolute;
  final double changePercent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color textAndIconColor;
    final Color backgroundColor;
    final String glyph;
    final String sign;

    if (changeAbsolute > 0) {
      // Rate went UP -> EGP weakened -> RED
      textAndIconColor = isDark ? AppColors.negativeDark : AppColors.negative;
      backgroundColor = isDark ? AppColors.negativeSurfaceDark : AppColors.negativeSurface;
      glyph = '▲';
      sign = '+';
    } else if (changeAbsolute < 0) {
      // Rate went DOWN -> EGP strengthened -> GREEN
      textAndIconColor = isDark ? AppColors.positiveDark : AppColors.positive;
      backgroundColor = isDark ? AppColors.positiveSurfaceDark : AppColors.positiveSurface;
      glyph = '▼';
      sign = '';
    } else {
      // Rate UNCHANGED (changeAbsolute == 0) -> NEUTRAL GRAY
      textAndIconColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
      backgroundColor = isDark ? AppColors.surfaceDark : AppColors.dividerLight.withValues(alpha: 0.5);
      glyph = '—';
      sign = '';
    }

    final formattedPercent = '$sign${changePercent.abs().toStringAsFixed(2)}%';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.badgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            glyph,
            style: AppTextStyles.badge.copyWith(
              color: textAndIconColor,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            formattedPercent,
            style: AppTextStyles.badge.copyWith(
              color: textAndIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
