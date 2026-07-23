import 'package:flutter/material.dart';

/// Centralized color palette — restrained, consistent, and contrast-checked
/// for both light and dark modes.
///
/// One primary, one positive, one negative, and a handful of neutrals.
/// Re-used everywhere via these constants — no ad-hoc colors in widgets.
class AppColors {
  AppColors._();

  // ── Brand / Primary ───────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFF4A9AF5);
  static const Color primaryDark = Color(0xFF1557B0);

  // ── Semantic — change indicators ──────────────────────────────────────
  /// Used for positive rate changes (▲).
  static const Color positive = Color(0xFF2E7D32);
  static const Color positiveSurface = Color(0xFFE8F5E9);
  static const Color positiveDark = Color(0xFF66BB6A);
  static const Color positiveSurfaceDark = Color(0xFF1B3A1D);

  /// Used for negative rate changes (▼).
  static const Color negative = Color(0xFFC62828);
  static const Color negativeSurface = Color(0xFFFFEBEE);
  static const Color negativeDark = Color(0xFFEF5350);
  static const Color negativeSurfaceDark = Color(0xFF3D1515);

  // ── Neutrals — Light mode ─────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF202124);
  static const Color textSecondaryLight = Color(0xFF5F6368);
  static const Color textTertiaryLight = Color(0xFF9AA0A6);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // ── Neutrals — Dark mode ──────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE8EAED);
  static const Color textSecondaryDark = Color(0xFF9AA0A6);
  static const Color textTertiaryDark = Color(0xFF5F6368);
  static const Color dividerDark = Color(0xFF3C4043);
}
