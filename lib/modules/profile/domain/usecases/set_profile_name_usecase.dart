import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';

class SetProfileNameUseCase {
  SetProfileNameUseCase(this._repository);

  final UserPreferencesRepository _repository;

  Future<void> call(String name) => _repository.saveProfileName(name);
}
