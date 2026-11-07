import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillswap/core/constants/app_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light([String fontFamily = 'Poppins']) =>
      _build(Brightness.light, fontFamily);

  static ThemeData dark([String fontFamily = 'Poppins']) =>
      _build(Brightness.dark, fontFamily);

  static ThemeData _build(Brightness brightness, String fontFamily) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      surface: isDark ? AppColors.surfaceDark : AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 19.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.border,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.dividerDark : AppColors.divider,
        thickness: 1.r,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: isDark ? AppColors.iconDark : AppColors.icon,
        textColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surface,
        indicatorColor: isDark
            ? AppColors.primary.withValues(alpha: 0.3)
            : AppColors.primarySoft,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(50.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
