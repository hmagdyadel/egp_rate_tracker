import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:egp_rate_tracker/core/theme/app_card_decoration.dart';
import 'package:egp_rate_tracker/core/theme/app_colors.dart';
import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/theme/app_text_styles.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_change_badge.dart';

/// Single row item in the currency exchange rate list.
class RateListItem extends StatelessWidget {
  const RateListItem({
    super.key,
    required this.rate,
    required this.onTap,
  });

  final CurrencyRate rate;
  final VoidCallback onTap;

  /// Returns a consistent 2-letter monogram initial for the currency code.
  static String currencyMonogram(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return 'US';
      case 'EUR':
        return 'EU';
      case 'GBP':
        return 'GB';
      case 'SAR':
        return 'SA';
      case 'JPY':
        return 'JP';
      default:
        return code.length >= 2 ? code.substring(0, 2) : code;
    }
  }

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

    final monogram = currencyMonogram(rate.code);
    final localizedName = _localizedName(rate.code, rate.name);
    final formattedRate = rate.rate.toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: appCardDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // ── Leading Avatar Monogram Chip ───────────────────────────
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

                // ── Currency Code & Name ────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        rate.code,
                        style: AppTextStyles.title.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        localizedName,
                        style: AppTextStyles.caption.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // ── Tabular-Figure Rate & Change Badge ─────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedRate,
                      style: AppTextStyles.rateDisplay.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    RateChangeBadge(
                      changeAbsolute: rate.changeAbsolute,
                      changePercent: rate.changePercent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
