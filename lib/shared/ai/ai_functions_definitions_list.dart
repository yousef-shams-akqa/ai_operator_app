import 'package:flutter_app_copilot/flutter_app_copilot.dart';
import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/modules/profile/domain/models/set_profile_name_params.dart';
import 'package:ai_operator_app/modules/settings/domain/models/set_dark_mode_params.dart';

/// Registry of Gemini function definitions for every [AiExecutableAction] use case.
abstract final class AIFunctionsDefinitionsList {
  AIFunctionsDefinitionsList._();

  static const _routePaths = [
    AppRoutes.home,
    AppRoutes.profile,
    AppRoutes.settings,
    AppRoutes.agent,
  ];

  static final List<FunctionDefinition> all = [
    FunctionDefinition(
      name: AIFunctionName.getProfileName.name,
      description: 'Reads the saved profile name from local preferences.',
    ),
    FunctionDefinition(
      name: AIFunctionName.setProfileName.name,
      description: 'Saves the profile name to local preferences.',
      parameters: [SetProfileNameParams.toFunctionParameter()],
    ),
    FunctionDefinition(
      name: AIFunctionName.getDarkMode.name,
      description: 'Reads whether dark mode is enabled.',
    ),
    FunctionDefinition(
      name: AIFunctionName.setDarkMode.name,
      description: 'Turns dark mode on or off.',
      parameters: [SetDarkModeParams.toFunctionParameter()],
    ),
    ...navigationFunctionDefinitions(locations: _routePaths),
  ];
}


enum AIFunctionName {
  getProfileName,
  setProfileName,
  getDarkMode,
  setDarkMode;

  static AIFunctionName? tryParse(String name) {
    for (final function in values) {
      if (function.name == name) return function;
    }
    return null;
  }
}

extension AIFunctionNameExtension on AIFunctionName {
  String get name => switch (this) {
        AIFunctionName.getProfileName => 'getProfileName',
        AIFunctionName.setProfileName => 'setProfileName',
        AIFunctionName.getDarkMode => 'getDarkMode',
        AIFunctionName.setDarkMode => 'setDarkMode',
      };
}
