import 'package:flutter_ai_operator/flutter_ai_operator.dart';
import 'package:ai_operator_app/core/domain/models/navigate_params.dart';
import 'package:ai_operator_app/core/domain/models/no_params.dart';
import 'package:ai_operator_app/core/domain/usecases/navigate_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/models/set_profile_name_params.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/get_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/models/set_dark_mode_params.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/get_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:ai_operator_app/shared/ai/ai_functions_definitions_list.dart';
import 'package:either_dart/either.dart';

/// Maps each [AIFunctionName] to its use case and builds that use case's input
/// from the model's arguments.
///
/// Adding a function means: add an [AIFunctionName], its definition in
/// `shared/ai`, a use case in `actions`, and a branch in [handle].
class AiActionHandlerImpl extends AiActionHandler {
  AiActionHandlerImpl({required super.actions});

  @override
  Future<Either<Error, String>> handle(FunctionCallResponse response) async {
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
        AIFunctionName.navigateGo => _run(
          _action<NavigateUseCase>(),
          NavigateParams.fromJson(args),
        ),
        AIFunctionName.navigatePush => _run(
          _action<NavigateUseCase>(),
          NavigateParams.fromJson(args).copyWith(push: true),
        ),
        AIFunctionName.navigateReplace => _run(
          _action<NavigateUseCase>(),
          NavigateParams.fromJson(args).copyWith(replace: true),
        ),
        AIFunctionName.navigatePop => _run(
          _action<NavigateUseCase>(),
          NavigateParams(pop: true),
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
