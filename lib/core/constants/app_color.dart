import 'package:flutter/material.dart';

abstract final class AppColors {
  // =========================
  // Brand / Primary
  // =========================
  static const Color primary = Color(0xFF630ED4);
  static const Color primaryDark = Color(0xFF4B0AA3);
  static const Color primaryLight = Color(0xFFEDE2FF);
  static const Color primarySoft = Color(0xFFF5EFFF);

  // =========================
  // Light Backgrounds & Surfaces
  // =========================
  static const Color background = Color(0xFFF8F9FF);
  static const Color backgroundSecondary = Color(0xFFEFF4FF);
  static const Color surface = Colors.white;
  static const Color surfaceSoft = Color(0xFFF6F3FF);

  // =========================
  // Dark Backgrounds & Surfaces
  // =========================
  static const Color backgroundDark = Color(0xFF0F0D17);
  static const Color backgroundSecondaryDark = Color(0xFF161322);
  static const Color surfaceDark = Color(0xFF1B1726);
  static const Color surfaceSoftDark = Color(0xFF262035);

  // =========================
  // Light Text
  // =========================
  static const Color textPrimary = Color(0xFF302A36);
  static const Color textSecondary = Color(0xFF6F6A76);
  static const Color textMuted = Color(0xFF9B97A3);
  static const Color textOnPrimary = Colors.white;

  // =========================
  // Dark Text
  // =========================
  static const Color textPrimaryDark = Color(0xFFF3F0F8);
  static const Color textSecondaryDark = Color(0xFFA8A3B4);
  static const Color textMutedDark = Color(0xFF787284);

  // =========================
  // Borders & Dividers
  // =========================
  static const Color border = Color(0xFFE5E1EC);
  static const Color divider = Color(0xFFEAE7F0);
  static const Color borderDark = Color(0xFF2C263B);
  static const Color dividerDark = Color(0xFF252033);

  // =========================
  // Status Colors
  // =========================
  static const Color success = Color(0xFF16B878);
  static const Color successLight = Color(0xFFE7F9F1);
  static const Color warning = Color(0xFFF2A93B);
  static const Color warningLight = Color(0xFFFFF4DF);
  static const Color error = Color(0xFFE85B65);
  static const Color errorLight = Color(0xFFFFE9EB);
  static const Color info = Color(0xFF5B8DEF);
  static const Color infoLight = Color(0xFFEAF1FF);

  // =========================
  // Misc
  // =========================
  static const Color online = Color(0xFF20C77A);
  static const Color icon = Color(0xFF6B6475);
  static const Color iconDark = Color(0xFFA19BAE);
  static const Color disabled = Color(0xFFD8D5DE);

  // ==========================================
  // Dynamic Context-Aware Helper Methods
  // ==========================================
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundOf(BuildContext context) =>
      isDark(context) ? backgroundDark : background;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? surfaceDark : surface;

  static Color surfaceSoftOf(BuildContext context) =>
      isDark(context) ? surfaceSoftDark : surfaceSoft;

  static Color textPrimaryOf(BuildContext context) =>
      isDark(context) ? textPrimaryDark : textPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      isDark(context) ? textSecondaryDark : textSecondary;

  static Color textMutedOf(BuildContext context) =>
      isDark(context) ? textMutedDark : textMuted;

  static Color borderOf(BuildContext context) =>
      isDark(context) ? borderDark : border;

  static Color dividerOf(BuildContext context) =>
      isDark(context) ? dividerDark : divider;

  static Color iconOf(BuildContext context) =>
      isDark(context) ? iconDark : icon;
}
