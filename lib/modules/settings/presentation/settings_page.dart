import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/core/viewmodel/app_state.dart';
import 'package:ai_operator_app/core/viewmodel/app_viewmodel.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
            Text(AppStrings.settingsBody, style: textTheme.bodyLarge),
            BlocBuilder<AppViewModel, AppState>(
              builder: (context, state) {
                return SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    AppStrings.darkModeTitle,
                    style: textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    AppStrings.darkModeSubtitle,
                    style: textTheme.bodySmall,
                  ),
                  value: state.isDarkMode,
                  onChanged: (value) {
                    context.read<AppViewModel>().setDarkMode(value);
                  },
                );
              },
            ),
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
