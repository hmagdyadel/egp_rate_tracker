/// Consistent spacing scale and shape tokens.
///
/// Use these everywhere instead of magic numbers — inconsistent radii/spacing
/// is the single biggest tell of an un-designed app.
class AppSpacing {
  AppSpacing._();

  // ── Spacing scale ─────────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // ── Shape ─────────────────────────────────────────────────────────────
  /// Standard card / container corner radius.
  static const double cardRadius = 12.0;

  /// Small element radius (badges, pills).
  static const double badgeRadius = 8.0;
}
