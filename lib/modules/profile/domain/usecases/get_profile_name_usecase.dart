import 'package:ai_operator_app/core/ai/interfaces/ai_executable_action.dart';
import 'package:ai_operator_app/core/domain/failures/user_preferences_failure.dart';
import 'package:ai_operator_app/core/domain/models/profile_name_output.dart';
import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';
import 'package:ai_operator_app/core/domain/models/no_params.dart';
import 'package:either_dart/either.dart';

class GetProfileNameUseCase
    implements AiExecutableAction<NoParams, ProfileNameOutput, UserPreferencesFailure> {
  GetProfileNameUseCase(this._repository);

  final UserPreferencesRepository _repository;

  @override
  Future<Either<UserPreferencesFailure, ProfileNameOutput>> execute(
    NoParams input,
  ) async {
    try {
      return Right(ProfileNameOutput(_repository.profileName));
    } catch (error, stackTrace) {
      return Left(
        UserPreferencesFailure('Failed to load profile name', error, stackTrace),
      );
    }
  }
}
