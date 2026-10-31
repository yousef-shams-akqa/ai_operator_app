import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class HomeDestinationCard extends StatelessWidget {
  const HomeDestinationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.emphasized = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconBackground = emphasized
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final iconColor =
        emphasized ? colorScheme.onPrimary : colorScheme.primary;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  icon,
                  size: AppSizes.iconMd,
                  color: iconColor,
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: AppSizes.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
