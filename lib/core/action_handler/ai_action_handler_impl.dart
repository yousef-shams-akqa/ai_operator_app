import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter_app_copilot/flutter_app_copilot.dart';
import 'package:ai_operator_app/core/domain/models/no_params.dart';
import 'package:ai_operator_app/modules/profile/domain/models/set_profile_name_params.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/get_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/models/set_dark_mode_params.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/get_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:ai_operator_app/shared/ai/ai_functions_definitions_list.dart';

/// Maps each [AIFunctionName] to its use case and builds that use case's input
/// from the model's arguments.
///
/// Adding a function means: add an [AIFunctionName], its definition in
/// `shared/ai`, a use case in `actions`, and a branch in [handle].
class AiActionHandlerImpl extends AiActionHandler {
  AiActionHandlerImpl({required super.actions});

  @override
  Future<Either<Error, String>> handle(FunctionCallResponse response) async {
    if(kDebugMode) debugPrint('[AiActionHandlerImpl] ${DateTime.now().toIso8601String()} handle: FunctionCallResponse(functionName: ${response.functionName}, functionArgs: ${response.functionArgs})');
    final navigationMethod = NavigationMethod.fromFunctionName(
      response.functionName,
    );
    if (navigationMethod != null) {
      return _navigate(navigationMethod, response.functionArgs);
    }

    final function = AIFunctionName.tryParse(response.functionName);
    if (function == null) {
      return Left(StateError('Unknown function: ${response.functionName}'));
    }

    final args = response.functionArgs;

    try {
      return await switch (function) {
        AIFunctionName.getProfileName => _run(
          _action<GetProfileNameUseCase>(),
          const NoParams(),
        ),
        AIFunctionName.setProfileName => _run(
          _action<SetProfileNameUseCase>(),
          SetProfileNameParams.fromJson(args),
        ),
        AIFunctionName.getDarkMode => _run(
          _action<GetDarkModeUseCase>(),
          const NoParams(),
        ),
        AIFunctionName.setDarkMode => _run(
          _action<SetDarkModeUseCase>(),
          SetDarkModeParams.fromJson(args),
        ),
      };
    } catch (error) {
      // Model arguments are untrusted. Report bad ones back so the model can
      // retry; anything else (like a missing registration) is a bug.
      if (error is TypeError || error is FormatException || error is AssertionError) {
        return Left(
          StateError('Invalid arguments for ${response.functionName}: $error'),
        );
      }
      rethrow;
    }
  }

  /// Navigation tools come from the package, so their arguments are parsed by
  /// [NavigationInput] and they are not part of [AIFunctionName].
  Future<Either<Error, String>> _navigate(
    NavigationMethod method,
    Map<String, dynamic> args,
  ) async {
    final input = NavigationInput.fromArgs(method, args);
    if (input.isLeft) return Left(input.left);
    return _run(_action<GoRouterNavigationAction>(), input.right);
  }

  T _action<T extends AiExecutableAction>() {
    for (final action in actions) {
      if (action is T) {
        return action;
      }
    }
    throw StateError('No ${T.toString()} registered in actions');
  }

  Future<Either<Error, String>> _run<Input>(
    AiExecutableAction<Input, Object?, Error> action, Input input,
  ) async {
    final result = await action.execute(input);

    return result.fold(
      (failure) => Left(failure),
      (output) => Right(output.toString()),
    );
  }
}
