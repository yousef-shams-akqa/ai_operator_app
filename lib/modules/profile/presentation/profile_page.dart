import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/core/viewmodel/app_state.dart';
import 'package:ai_operator_app/core/viewmodel/app_viewmodel.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _nameController.text = context.read<AppViewModel>().state.name;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }
    await context.read<AppViewModel>().setName(name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppViewModel, AppState>(
      listenWhen: (previous, current) => previous.name != current.name,
      listener: (context, state) {
        if (_nameController.text != state.name) {
          _nameController.text = state.name;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.profileTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.defaultHorizontalPadding),
          child: BlocBuilder<AppViewModel, AppState>(
            builder: (context, state) {
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
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: AppStrings.profileNameLabel,
                      hintText: AppStrings.profileNameHint,
                    ),
                    onSubmitted: (_) => _submitName(),
                  ),
                  if (state.name.isNotEmpty)
                    Text(
                      '${AppStrings.profileSavedName}: ${state.name}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  FilledButton(
                    onPressed: _submitName,
                    child: const Text(AppStrings.profileSaveName),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text(AppStrings.goToHome),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
