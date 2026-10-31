import 'package:ai_operator_app/shared/theme/app_fonts.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:flutter/material.dart';

abstract final class AppSnackBar {
  static void showMessage(
    BuildContext context,
    String message, {
    int maxLines = 4,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      buildMessage(context, message, maxLines: maxLines),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(buildError(context, message));
  }

  static SnackBar buildMessage(
    BuildContext context,
    String message, {
    int maxLines = 4,
  }) {
    final snackBarTheme = Theme.of(context).snackBarTheme;

    return SnackBar(
      behavior: snackBarTheme.behavior ?? SnackBarBehavior.floating,
      backgroundColor: snackBarTheme.backgroundColor,
      shape: snackBarTheme.shape,
      content: Text(
        message,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: snackBarTheme.contentTextStyle,
      ),
    );
  }

  static SnackBar buildError(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final snackBarTheme = Theme.of(context).snackBarTheme;

    return SnackBar(
      behavior: snackBarTheme.behavior ?? SnackBarBehavior.floating,
      backgroundColor: colorScheme.error,
      shape: snackBarTheme.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
      content: Text(
        message,
        style: AppFonts.bodyMedium.copyWith(color: colorScheme.onError),
      ),
    );
  }
}
