import 'package:flutter/material.dart';

import 'app_spacing.dart';

/// Centralized card decoration with soft subtle elevation shadow for both light & dark modes.
BoxDecoration appCardDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return BoxDecoration(
    color: theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
    border: Border.all(
      color: theme.colorScheme.outline,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.black.withValues(alpha: 0.04),
        blurRadius: isDark ? 16 : 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
