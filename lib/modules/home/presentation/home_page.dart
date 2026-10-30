import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.defaultHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.lg,
          children: [
            Text(AppStrings.homeBody, style: Theme.of(context).textTheme.bodyLarge),
            FilledButton(
              onPressed: () => context.go(AppRoutes.profile),
              child: const Text(AppStrings.goToProfile),
            ),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.settings),
              child: const Text(AppStrings.goToSettings),
            ),
          ],
        ),
      ),
    );
  }
}
