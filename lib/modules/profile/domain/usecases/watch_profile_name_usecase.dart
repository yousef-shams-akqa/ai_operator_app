import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';

class WatchProfileNameUseCase {
  WatchProfileNameUseCase(this._repository);

  final UserPreferencesRepository _repository;

  Stream<String?> call() => _repository.watchProfileName();
}
