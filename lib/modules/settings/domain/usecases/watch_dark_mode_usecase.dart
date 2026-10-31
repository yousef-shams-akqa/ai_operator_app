import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';

class WatchDarkModeUseCase {
  WatchDarkModeUseCase(this._repository);

  final UserPreferencesRepository _repository;

  Stream<bool> call() => _repository.watchDarkModeEnabled();
}
