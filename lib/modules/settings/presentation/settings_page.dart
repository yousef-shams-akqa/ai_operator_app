import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_fonts.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.defaultHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.lg,
          children: [
            Text(AppStrings.settingsBody, style: AppFonts.bodyLarge),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text(AppStrings.goToHome),
            ),
          ],
        ),
      ),
    );
  }
}
