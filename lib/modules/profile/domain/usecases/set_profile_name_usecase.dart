import 'package:flutter_ai_operator/flutter_ai_operator.dart';
import 'package:ai_operator_app/core/domain/failures/user_preferences_failure.dart';
import 'package:ai_operator_app/core/domain/models/unit.dart';
import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';
import 'package:ai_operator_app/modules/profile/domain/models/set_profile_name_params.dart';

class SetProfileNameUseCase
    implements
        AiExecutableAction<SetProfileNameParams, Unit, UserPreferencesFailure> {
  SetProfileNameUseCase(this._repository);

  final UserPreferencesRepository _repository;

  @override
  Future<Either<UserPreferencesFailure, Unit>> execute(
    SetProfileNameParams input,
  ) async {
    try {
      await _repository.saveProfileName(input.name);
      return const Right(Unit.unit);
    } catch (error, stackTrace) {
      return Left(
        UserPreferencesFailure('Failed to save profile name', error, stackTrace),
      );
    }
  }
}
