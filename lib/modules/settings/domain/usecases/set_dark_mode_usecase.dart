import 'package:flutter_app_copilot/flutter_app_copilot.dart';
import 'package:ai_operator_app/core/domain/failures/user_preferences_failure.dart';
import 'package:ai_operator_app/core/domain/models/unit.dart';
import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';
import 'package:ai_operator_app/core/initializer/app_initializer.dart' show appThemeMode;
import 'package:ai_operator_app/modules/settings/domain/models/set_dark_mode_params.dart';
import 'package:flutter/material.dart' show ThemeMode;

class SetDarkModeUseCase implements AiExecutableAction<SetDarkModeParams, Unit, UserPreferencesFailure> {
  SetDarkModeUseCase(this._repository);

  final UserPreferencesRepository _repository;

  @override
  Future<Either<UserPreferencesFailure, Unit>> execute(SetDarkModeParams input) async {
    try {
      await _repository.saveDarkModeEnabled(input.enabled);
      appThemeMode.value = input.enabled ? ThemeMode.dark : ThemeMode.light;
      return const Right(Unit.unit);
    } catch (error, stackTrace) {
      return Left(
        UserPreferencesFailure(
          'Failed to save dark mode preference',
          error,
          stackTrace,
        ),
      );
    }
  }
}
