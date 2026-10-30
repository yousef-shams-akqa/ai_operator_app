import 'package:ai_operator_app/core/data/repositories/user_preferences_repository_impl.dart';
import 'package:ai_operator_app/core/firebase/app_check_setup.dart';
import 'package:ai_operator_app/core/navigation/app_router.dart';
import 'package:ai_operator_app/core/storage/app_preferences.dart';
import 'package:ai_operator_app/core/viewmodel/app_state.dart';
import 'package:ai_operator_app/core/viewmodel/app_viewmodel.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/get_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/get_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:ai_operator_app/shared/constants/app_strings.dart';
import 'package:ai_operator_app/shared/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  // ensure initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppCheckSetup.activateAppCheck();
  await AppPreferences.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userPreferencesRepository =
        UserPreferencesRepositoryImpl(AppPreferences());

    return BlocProvider(
      create: (context) => AppViewModel(
        getProfileName: GetProfileNameUseCase(userPreferencesRepository),
        setProfileName: SetProfileNameUseCase(userPreferencesRepository),
        getDarkMode: GetDarkModeUseCase(userPreferencesRepository),
        setDarkMode: SetDarkModeUseCase(userPreferencesRepository),
      )..initialize(),
      child: BlocBuilder<AppViewModel, AppState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: AppStrings.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
