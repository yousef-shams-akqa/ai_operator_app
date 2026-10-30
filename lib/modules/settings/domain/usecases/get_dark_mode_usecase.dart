import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';

class GetDarkModeUseCase {
  GetDarkModeUseCase(this._repository);

  final UserPreferencesRepository _repository;

  bool call() => _repository.isDarkModeEnabled;
}
