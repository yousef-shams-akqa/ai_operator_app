import '../../../packages/flutter_ai_operator/lib/src/models/function_definition.dart';
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

  static const _locationParameterValue = FunctionParameterValue(
    type: FunctionParameterType.string,
    description: 'App route path to open.',
    possibleValues: _routePaths,
  );

  static const _locationParameter = FunctionParameter(
    key: 'location',
    value: _locationParameterValue,
  );

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
    FunctionDefinition(
      name: AIFunctionName.navigateGo.name,
      description:
          'Navigates to a route using go (replaces the current route).',
      parameters: [_locationParameter],
    ),
    FunctionDefinition(
      name: AIFunctionName.navigatePush.name,
      description: 'Pushes a route onto the navigation stack.',
      parameters: [_locationParameter],
    ),
    FunctionDefinition(
      name: AIFunctionName.navigateReplace.name,
      description: 'Replaces the top route on the navigation stack.',
      parameters: [_locationParameter],
    ),
    FunctionDefinition(
      name: AIFunctionName.navigatePop.name,
      description: 'Pops the current route off the navigation stack.',
    ),
  ];
}


enum AIFunctionName {
  getProfileName,
  setProfileName,
  getDarkMode,
  setDarkMode,
  navigateGo,
  navigatePush,
  navigateReplace,
  navigatePop;

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
        AIFunctionName.navigateGo => 'navigateGo',
        AIFunctionName.navigatePush => 'navigatePush',
        AIFunctionName.navigateReplace => 'navigateReplace',
        AIFunctionName.navigatePop => 'navigatePop',
      };
}
