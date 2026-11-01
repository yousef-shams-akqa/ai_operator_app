import 'package:ai_operator_app/core/action_handler/ai_action_handler_impl.dart';
import '../../../packages/flutter_ai_operator/lib/src/constants/ai_constants.dart';
import '../../../packages/flutter_ai_operator/lib/src/models/ai_configuration.dart';
import '../../../packages/flutter_ai_operator/lib/src/models/ai_provider.dart';
import '../../../packages/flutter_ai_operator/lib/src/service/ai_service.dart';
import '../../../packages/flutter_ai_operator/lib/src/service/ai_service_factory.dart';
import 'package:ai_operator_app/core/data/repositories/user_preferences_repository_impl.dart';
import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';
import 'package:ai_operator_app/core/domain/models/no_params.dart';
import 'package:ai_operator_app/core/domain/usecases/navigate_usecase.dart';
import 'package:ai_operator_app/core/navigation/app_router.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/get_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/get_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:ai_operator_app/shared/ai/ai_functions_definitions_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ai_operator_app/core/firebase/app_check_setup.dart';
import 'package:ai_operator_app/core/storage/app_preferences.dart';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';

ValueNotifier<ThemeMode> appThemeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

class AppInitializer {
  static final UserPreferencesRepository userPreferencesRepository =
      UserPreferencesRepositoryImpl(AppPreferences());

  static Future<void> initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await AppCheckSetup.activateAppCheck();
    await AppPreferences.initialize();
    final themeMode = await loadThemeMode();
    appThemeMode.value = themeMode;
    await initializeAI();
  }

  static Future<ThemeMode> loadThemeMode() async {
    final darkMode =
        await GetDarkModeUseCase(userPreferencesRepository).execute(NoParams());
    final isDarkMode = darkMode.fold((_) => false, (value) => value.enabled);
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }


  /// The AI service the app uses. Set by [initializeAI].
  static late final AIService aiService;

  static Future<void> initializeAI() async {
    aiService = const AIServiceFactory().create(
      provider: AIProvider.gemini,
      configuration: AIConfiguration(
        systemPrompt: AIConstants.systemPrompt,
        functionDefinitions: AIFunctionsDefinitionsList.all,
      ),
      actionHandler: AiActionHandlerImpl(
        actions: [
          GetProfileNameUseCase(userPreferencesRepository),
          SetProfileNameUseCase(userPreferencesRepository),
          GetDarkModeUseCase(userPreferencesRepository),
          SetDarkModeUseCase(userPreferencesRepository),
          NavigateUseCase(appRouter)
        ],
      ),
    );
  }
}