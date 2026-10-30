import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';

class SetDarkModeUseCase {
  SetDarkModeUseCase(this._repository);

  final UserPreferencesRepository _repository;

  Future<void> call(bool enabled) => _repository.saveDarkModeEnabled(enabled);
}
