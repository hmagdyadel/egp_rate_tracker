import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:egp_rate_tracker/core/theme/app_card_decoration.dart';
import 'package:egp_rate_tracker/core/theme/app_colors.dart';
import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/theme/app_text_styles.dart';
import 'package:egp_rate_tracker/features/rates/domain/entities/currency_rate.dart';
import 'package:egp_rate_tracker/features/rates/presentations/widgets/rate_change_badge.dart';

/// Single row item in the currency exchange rate list with smooth entrance
/// fade animation and price change transition.
class RateListItem extends StatefulWidget {
  const RateListItem({
    super.key,
    required this.rate,
    required this.onTap,
    this.index = 0,
  });

  final CurrencyRate rate;
  final VoidCallback onTap;
  final int index;

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
  State<RateListItem> createState() => _RateListItemState();
}

class _RateListItemState extends State<RateListItem>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _pulseScaleAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    // Continuous pulse animation scaling container from 1.0 down to 0.97 and back
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _entranceController.forward().then((_) {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUsd = widget.rate.code.toUpperCase() == 'USD';

    final monogram = RateListItem.currencyMonogram(widget.rate.code);
    final localizedName = RateListItem._localizedName(widget.rate.code, widget.rate.name);
    final formattedRate = widget.rate.rate.toStringAsFixed(2);

    // Base card decoration with special USD accent border
    final baseDecoration = appCardDecoration(context);
    final usdDecoration = isUsd
        ? baseDecoration.copyWith(
            border: Border.all(
              color: isDark
                  ? AppColors.primaryLight.withValues(alpha: 0.45)
                  : AppColors.primary.withValues(alpha: 0.35),
              width: 1.5,
            ),
          )
        : baseDecoration;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _pulseScaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
          decoration: usdDecoration,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
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
                        color: isUsd
                            ? AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.18)
                            : AppColors.primary.withValues(alpha: isDark ? 0.20 : 0.10),
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
                          Row(
                            children: [
                              Text(
                                widget.rate.code,
                                style: AppTextStyles.title.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (isUsd) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'PRIMARY',
                                    style: AppTextStyles.badge.copyWith(
                                      color: isDark ? AppColors.primaryLight : AppColors.primary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ],
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -0.10),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        key: ValueKey('${widget.rate.code}_$formattedRate'),
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
                            changeAbsolute: widget.rate.changeAbsolute,
                            changePercent: widget.rate.changePercent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
