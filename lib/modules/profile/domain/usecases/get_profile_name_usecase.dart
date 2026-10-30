import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';

class GetProfileNameUseCase {
  GetProfileNameUseCase(this._repository);

  final UserPreferencesRepository _repository;

  String? call() => _repository.profileName;
}
