import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFDBEAFE);

  // Neutrals
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);

  // Overlays
  static const Color scrim = Color(0x800F172A);
  static const Color shadow = Color(0x1A0F172A);
}
