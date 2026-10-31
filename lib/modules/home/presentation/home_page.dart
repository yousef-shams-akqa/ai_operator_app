import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/modules/home/presentation/widgets/home_destination_card.dart';
import 'package:ai_operator_app/modules/home/presentation/widgets/home_welcome_section.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.defaultHorizontalPadding),
              children: [
                const HomeWelcomeSection(),
                SizedBox(height: AppSpacing.sectionGap),
                Text(
                  AppStrings.homeQuickActionsTitle,
                  style: textTheme.titleMedium,
                ),
                SizedBox(height: AppSpacing.md),
                HomeDestinationCard(
                  emphasized: true,
                  icon: Icons.chat_bubble_outline,
                  title: AppStrings.goToAgent,
                  subtitle: AppStrings.homeAgentDescription,
                  onTap: () => context.push(AppRoutes.agent),
                ),
                SizedBox(height: AppSpacing.md),
                HomeDestinationCard(
                  icon: Icons.person_outline,
                  title: AppStrings.goToProfile,
                  subtitle: AppStrings.profileBody,
                  onTap: () => context.go(AppRoutes.profile),
                ),
                SizedBox(height: AppSpacing.md),
                HomeDestinationCard(
                  icon: Icons.settings_outlined,
                  title: AppStrings.goToSettings,
                  subtitle: AppStrings.settingsBody,
                  onTap: () => context.go(AppRoutes.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
