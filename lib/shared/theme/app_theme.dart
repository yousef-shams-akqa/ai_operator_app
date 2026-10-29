import 'package:ai_operator_app/shared/theme/app_colors.dart';
import 'package:ai_operator_app/shared/theme/app_fonts.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = _lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.family,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme,
      appBarTheme: _appBarTheme,
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppSizes.borderWidth,
        space: AppSizes.borderWidth,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: const BorderSide(
            color: AppColors.border,
            width: AppSizes.borderWidth,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppFonts.bodyMedium.copyWith(color: AppColors.textSecondary),
        labelStyle: AppFonts.labelMedium,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: AppSizes.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: AppSizes.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: AppSizes.borderWidthThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppSizes.borderWidth,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppFonts.bodyMedium.copyWith(color: AppColors.surface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }

  static ColorScheme get _lightColorScheme {
    return ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.surface,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.info,
      onSecondary: AppColors.surface,
      secondaryContainer: AppColors.infoLight,
      onSecondaryContainer: AppColors.info,
      tertiary: AppColors.success,
      onTertiary: AppColors.surface,
      tertiaryContainer: AppColors.successLight,
      onTertiaryContainer: AppColors.success,
      error: AppColors.error,
      onError: AppColors.surface,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
      shadow: AppColors.shadow,
      scrim: AppColors.scrim,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.primaryLight,
      surfaceContainerHighest: AppColors.surfaceVariant,
    );
  }

  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: AppFonts.displayLarge,
      headlineLarge: AppFonts.headlineLarge,
      headlineMedium: AppFonts.headlineMedium,
      titleLarge: AppFonts.titleLarge,
      titleMedium: AppFonts.titleMedium,
      bodyLarge: AppFonts.bodyLarge,
      bodyMedium: AppFonts.bodyMedium,
      bodySmall: AppFonts.bodySmall,
      labelLarge: AppFonts.labelLarge,
      labelMedium: AppFonts.labelMedium,
      labelSmall: AppFonts.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppFonts.titleLarge,
      toolbarHeight: AppSizes.appBarHeight,
    );
  }

  static FilledButtonThemeData _filledButtonTheme(ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.buttonHeightMd),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: AppFonts.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.buttonHeightMd),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        foregroundColor: colorScheme.primary,
        textStyle: AppFonts.labelLarge,
        side: BorderSide(color: colorScheme.outline, width: AppSizes.borderWidth),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.buttonHeightSm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        foregroundColor: colorScheme.primary,
        textStyle: AppFonts.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }
}
