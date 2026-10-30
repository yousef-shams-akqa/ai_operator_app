import 'package:ai_operator_app/shared/theme/app_colors.dart';
import 'package:ai_operator_app/shared/theme/app_fonts.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(
        colorScheme: _lightColorScheme,
        scaffoldBackground: AppColors.background,
      );

  static ThemeData get dark => _buildTheme(
        colorScheme: _darkColorScheme,
        scaffoldBackground: AppColors.backgroundDark,
      );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
  }) {
    final textTheme = _textThemeFor(colorScheme);
    final appBarTheme = _appBarThemeFor(colorScheme);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.family,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      appBarTheme: appBarTheme,
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: AppSizes.borderWidth,
        space: AppSizes.borderWidth,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidth,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: AppFonts.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
        labelStyle: AppFonts.labelMedium.copyWith(color: colorScheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppSizes.borderWidthThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppSizes.borderWidth,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppFonts.bodyMedium.copyWith(color: colorScheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
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

  static ColorScheme get _darkColorScheme {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.textPrimaryDark,
      primaryContainer: AppColors.primaryLightDark,
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.info,
      onSecondary: AppColors.textPrimaryDark,
      secondaryContainer: AppColors.infoLight.withValues(alpha: 0.2),
      onSecondaryContainer: AppColors.infoLight,
      tertiary: AppColors.success,
      onTertiary: AppColors.textPrimaryDark,
      tertiaryContainer: AppColors.successLight.withValues(alpha: 0.2),
      onTertiaryContainer: AppColors.successLight,
      error: AppColors.error,
      onError: AppColors.textPrimaryDark,
      errorContainer: AppColors.errorLight.withValues(alpha: 0.2),
      onErrorContainer: AppColors.errorLight,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.dividerDark,
      shadow: AppColors.shadowDark,
      scrim: AppColors.scrimDark,
      inverseSurface: AppColors.textPrimaryDark,
      onInverseSurface: AppColors.surfaceDark,
      inversePrimary: AppColors.primary,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
    );
  }

  static TextTheme _textThemeFor(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: AppFonts.displayLarge.copyWith(color: colorScheme.onSurface),
      headlineLarge: AppFonts.headlineLarge.copyWith(color: colorScheme.onSurface),
      headlineMedium: AppFonts.headlineMedium.copyWith(color: colorScheme.onSurface),
      titleLarge: AppFonts.titleLarge.copyWith(color: colorScheme.onSurface),
      titleMedium: AppFonts.titleMedium.copyWith(color: colorScheme.onSurface),
      bodyLarge: AppFonts.bodyLarge.copyWith(color: colorScheme.onSurface),
      bodyMedium: AppFonts.bodyMedium.copyWith(color: colorScheme.onSurface),
      bodySmall: AppFonts.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
      labelLarge: AppFonts.labelLarge.copyWith(color: colorScheme.onSurface),
      labelMedium: AppFonts.labelMedium.copyWith(color: colorScheme.onSurfaceVariant),
      labelSmall: AppFonts.labelSmall.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }

  static AppBarTheme _appBarThemeFor(ColorScheme colorScheme) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppFonts.titleLarge.copyWith(color: colorScheme.onSurface),
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
