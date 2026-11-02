import 'dart:async' show Completer;

import 'package:flutter_app_copilot/flutter_app_copilot.dart';
import 'package:ai_operator_app/core/navigation/app_routes.dart';
import 'package:ai_operator_app/core/domain/failures/navigation_failure.dart';
import 'package:ai_operator_app/core/domain/models/unit.dart';
import 'package:ai_operator_app/core/domain/models/navigate_params.dart';
import 'package:go_router/go_router.dart';

class NavigateUseCase implements AiExecutableAction<NavigateParams, Unit, NavigationFailure> {

  NavigateUseCase(this._router);

  final GoRouter _router;

  Completer<void>? _completer;

  // Wait at least 2 seconds before navigating again
  final waitAtLeast = const Duration(seconds: 2);

  @override
  Future<Either<NavigationFailure, Unit>> execute(NavigateParams input) async {
    await _completer?.future;
    if(_completer?.isCompleted == true || _completer == null) _completer = Completer<void>();
    try {
      if (input.pop) {
        _router.pop(input.popResult);
        return const Right(Unit.unit);
      }

      final location = _locationWithParameters(input);

      // Tabs always switch with go. Pushing or replacing onto a tab duplicates
      // the shell's page key and crashes the Navigator.
      if (input.replace && !_isTabLocation(location)) {
        _router.replace(location, extra: input.extra);
      } else if (input.push && !_isTabLocation(location)) {
        _router.push(location, extra: input.extra);
      } else {
        _router.go(location, extra: input.extra);
      }
      return const Right(Unit.unit);
    } catch (error, stackTrace) {
      return Left(
        NavigationFailure('Navigation failed', error, stackTrace),
      );
    } finally {
      // Wait at least 2 seconds before navigating again
      Future.delayed(waitAtLeast, () {
        if(_completer?.isCompleted != true) _completer?.complete();
      });
    }
  }

  bool _isTabLocation(String location) {
    return AppRoutes.tabs.contains(Uri.parse(location).path);
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
