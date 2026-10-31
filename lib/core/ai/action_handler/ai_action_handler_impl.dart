import 'package:ai_operator_app/core/ai/models/function_call_response.dart';
import 'package:ai_operator_app/core/ai/interfaces/ai_action_handler.dart';
import 'package:ai_operator_app/core/ai/interfaces/ai_executable_action.dart';
import 'package:ai_operator_app/core/domain/models/navigate_params.dart';
import 'package:ai_operator_app/core/domain/usecases/navigate_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/get_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/get_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:ai_operator_app/shared/ai/ai_functions_definitions_list.dart';
import 'package:either_dart/either.dart';

class AiActionHandlerImpl extends AiActionHandler {
  AiActionHandlerImpl({required super.actions});

  @override
  Future<Either<Error, String>> handle(FunctionCallResponse response) async {
    final function = AIFunctionName.tryParse(response.functionName);
    if (function == null) {
      return Left(StateError('Unknown function: ${response.functionName}'));
    }

    final args = response.functionArgs;

    switch (function) {
      case AIFunctionName.getProfileName:
        return _executeAction(_action<GetProfileNameUseCase>(), args);
      case AIFunctionName.setProfileName:
        return _executeAction(_action<SetProfileNameUseCase>(), args);
      case AIFunctionName.getDarkMode:
        return _executeAction(_action<GetDarkModeUseCase>(), args);
      case AIFunctionName.setDarkMode:
        return _executeAction(_action<SetDarkModeUseCase>(), args);
      case AIFunctionName.navigateGo:
        return _executeNavigate(NavigateParams.fromJson(args));
      case AIFunctionName.navigatePush:
        return _executeNavigate(
          NavigateParams.fromJson(args).copyWith(push: true),
        );
      case AIFunctionName.navigateReplace:
        return _executeNavigate(
          NavigateParams.fromJson(args).copyWith(replace: true),
        );
      case AIFunctionName.navigatePop:
        return _executeNavigate(NavigateParams(pop: true));
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

  Future<Either<Error, String>> _executeNavigate(NavigateParams params) async {
    final result = await _action<NavigateUseCase>().execute(params);
    return result.fold(
      (failure) => Left(failure),
      (output) => Right(output.toString()),
    );
  }

  Future<Either<Error, String>> _executeAction(
    AiExecutableAction<dynamic, dynamic, Error> action,
    Map<String, dynamic> args,
  ) async {
    final input = action.fromJson(args);
    final result = await action.execute(input);

    return result.fold(
      (failure) => Left(failure),
      (output) => Right(output.toString()),
    );
  }
}
