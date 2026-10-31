import 'package:ai_operator_app/core/ai/interfaces/ai_executable_action.dart';
import 'package:ai_operator_app/core/domain/failures/navigation_failure.dart';
import 'package:ai_operator_app/core/domain/models/unit.dart';
import 'package:ai_operator_app/core/domain/models/navigate_params.dart';
import 'package:either_dart/either.dart';
import 'package:go_router/go_router.dart';

class NavigateUseCase implements AiExecutableAction<NavigateParams, Unit, NavigationFailure> {

  NavigateUseCase(this._router);

  final GoRouter _router;


  @override
  NavigateParams fromJson(Map<String, dynamic> json) =>
      NavigateParams.fromJson(json);

  @override
  Future<Either<NavigationFailure, Unit>> execute(NavigateParams input) async {
    final router = _router;
    try {
      if (input.pop) {
        router.pop(input.popResult);
        return const Right(Unit.unit);
      }

      final location = _locationWithParameters(input);

      if (input.replace) {
        router.replace(location, extra: input.extra);
      } else if (input.push) {
        router.push(location, extra: input.extra);
      } else {
        router.go(location, extra: input.extra);
      }

      return const Right(Unit.unit);
    } catch (error, stackTrace) {
      return Left(
        NavigationFailure('Navigation failed', error, stackTrace),
      );
    }
  }

  String _locationWithParameters(NavigateParams input) {
    var path = input.location!;

    final pathParameters = input.pathParameters;
    if (pathParameters != null) {
      for (final entry in pathParameters.entries) {
        path = path.replaceAll(':${entry.key}', entry.value);
      }
    }

    final queryParameters = input.queryParameters;
    if (queryParameters == null || queryParameters.isEmpty) {
      return path;
    }

    return Uri(path: path, queryParameters: queryParameters).toString();
  }
}
