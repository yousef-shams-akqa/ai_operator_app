import 'package:ai_operator_app/core/initializer/app_initializer.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/watch_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/presentation/view/components/profile_name_form.dart';
import 'package:ai_operator_app/modules/profile/presentation/viewmodel/profile_state.dart'
    show ProfileState, ProfileError, ProfileLoading;
import 'package:ai_operator_app/modules/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AppInitializer.userPreferencesRepository;
    return BlocProvider(
      create: (_) => ProfileViewModel(
        watchProfileName: WatchProfileNameUseCase(repository),
        setProfileName: SetProfileNameUseCase(repository),
      ),
      child: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.toString())),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;
          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.profileTitle),
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.defaultHorizontalPadding),
              child: ProfileNameForm(
                savedName: state.name,
                isLoading: isLoading,
                onSave: (name) => context.read<ProfileViewModel>().setName(name),
              ),
            ),
          );
        },
      ),
    );
  }
}
