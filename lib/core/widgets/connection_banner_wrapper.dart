import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'package:egp_rate_tracker/core/di/dependency_injection.dart';
import 'package:egp_rate_tracker/core/theme/app_colors.dart';
import 'package:egp_rate_tracker/core/theme/app_spacing.dart';
import 'package:egp_rate_tracker/core/theme/app_text_styles.dart';
import 'package:egp_rate_tracker/features/rates/presentations/cubit/rates_cubit.dart';

/// Floating network connectivity banner wrapper around the application layout.
///
/// Features:
/// - Displays a floating red banner when device goes offline
/// - Displays a floating green banner for 2.5s when device reconnects
/// - Auto-triggers [RatesCubit.fetchRates] on reconnection to pick up live data
class ConnectionBannerWrapper extends StatefulWidget {
  const ConnectionBannerWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ConnectionBannerWrapper> createState() => _ConnectionBannerWrapperState();
}

class _ConnectionBannerWrapperState extends State<ConnectionBannerWrapper> {
  bool? _wasOffline;
  bool _showOnlineFlash = false;
  Timer? _flashTimer;

  void _handleConnectivityChange(bool isConnected) {
    if (_wasOffline == null) {
      _wasOffline = !isConnected;
      return;
    }

    if (!isConnected) {
      // Transitioned to offline
      _wasOffline = true;
      _flashTimer?.cancel();
      if (_showOnlineFlash) {
        setState(() {
          _showOnlineFlash = false;
        });
      }
    } else if (_wasOffline == true) {
      // Transitioned from offline -> online (reconnected!)
      _wasOffline = false;
      _flashTimer?.cancel();

      setState(() {
        _showOnlineFlash = true;
      });

      // Auto-trigger refresh to pick up live data
      if (getIt.isRegistered<RatesCubit>()) {
        getIt<RatesCubit>().fetchRates(isRefresh: true);
      }

      // Hide green banner after 2.5 seconds
      _flashTimer = Timer(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() {
            _showOnlineFlash = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (context, connectivity, child) {
        final isConnected = !connectivity.contains(ConnectivityResult.none);
        _handleConnectivityChange(isConnected);

        final showOffline = !isConnected;
        final showBanner = showOffline || _showOnlineFlash;

        return Stack(
          fit: StackFit.expand,
          children: [
            child,

            if (showBanner)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: showOffline
                          ? AppColors.negative
                          : AppColors.positive,
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          showOffline
                              ? Icons.wifi_off_rounded
                              : Icons.wifi_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          showOffline
                              ? 'offline_banner'.tr()
                              : 'online_banner'.tr(),
                          style: AppTextStyles.captionBold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
