import 'package:flutter_ai_operator/flutter_ai_operator.dart';
import 'package:ai_operator_app/core/domain/failures/user_preferences_failure.dart';
import 'package:ai_operator_app/core/domain/models/dark_mode_output.dart';
import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';
import 'package:ai_operator_app/core/domain/models/no_params.dart';

class GetDarkModeUseCase
    implements AiExecutableAction<NoParams, DarkModeOutput, UserPreferencesFailure> {
  GetDarkModeUseCase(this._repository);

  final UserPreferencesRepository _repository;

  @override
  Future<Either<UserPreferencesFailure, DarkModeOutput>> execute(
    NoParams input,
  ) async {
    try {
      return Right(DarkModeOutput(_repository.isDarkModeEnabled));
    } catch (error, stackTrace) {
      return Left(
        UserPreferencesFailure('Failed to load dark mode preference', error, stackTrace),
      );
    }
  }
}
