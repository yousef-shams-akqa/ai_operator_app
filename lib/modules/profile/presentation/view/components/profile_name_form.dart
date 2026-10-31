import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_sizes.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileNameForm extends StatefulWidget {
  const ProfileNameForm({
    required this.savedName,
    required this.isLoading,
    required this.onSave,
    super.key,
  });

  final String savedName;
  final bool isLoading;
  final ValueChanged<String> onSave;

  @override
  State<ProfileNameForm> createState() => _ProfileNameFormState();
}

class _ProfileNameFormState extends State<ProfileNameForm> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.savedName;
  }

  @override
  void didUpdateWidget(ProfileNameForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.savedName != oldWidget.savedName &&
        _nameController.text != widget.savedName) {
      _nameController.text = widget.savedName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitName() {
    widget.onSave(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg,
      children: [
        Text(
          AppStrings.profileBody,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextField(
          controller: _nameController,
          enabled: !widget.isLoading,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: AppStrings.profileNameLabel,
            hintText: AppStrings.profileNameHint,
          ),
          onSubmitted: (_) => _submitName(),
        ),
        if (widget.savedName.isNotEmpty)
          Text(
            '${AppStrings.profileSavedName}: ${widget.savedName}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        FilledButton(
          onPressed: widget.isLoading ? null : _submitName,
          child: widget.isLoading
              ? const SizedBox(
                  height: AppSizes.iconMd,
                  width: AppSizes.iconMd,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(AppStrings.profileSaveName),
        ),
        TextButton(
          onPressed: widget.isLoading ? null : () => context.go(AppRoutes.home),
          child: const Text(AppStrings.goToHome),
        ),
      ],
    );
  }
}
