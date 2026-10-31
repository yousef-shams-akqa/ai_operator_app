import 'package:ai_operator_app/core/data/repositories/user_preferences_repository_impl.dart';
import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/core/storage/app_preferences.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/get_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/presentation/viewmodel/settings_state.dart'
    show SettingsState, SettingsError, SettingsLoading;
import 'package:ai_operator_app/modules/settings/presentation/viewmodel/settings_viewmodel.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = UserPreferencesRepositoryImpl(AppPreferences());
    return BlocProvider(
      create: (_) => SettingsViewModel(
        getDarkMode: GetDarkModeUseCase(repository),
        setDarkMode: SetDarkModeUseCase(repository),
      )..load(),
      child: BlocConsumer<SettingsViewModel, SettingsState>(
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.toString())),
            );
          }
        },
        builder: (context, state) {
          final textTheme = Theme.of(context).textTheme;
          final isLoading = state is SettingsLoading;
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
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppStrings.darkModeTitle,
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      AppStrings.darkModeSubtitle,
                      style: textTheme.bodySmall,
                    ),
                    value: state.isDarkModeEnabled,
                    onChanged: isLoading
                        ? null
                        : (value) => context.read<SettingsViewModel>().setDarkMode(value),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text(AppStrings.goToHome),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
