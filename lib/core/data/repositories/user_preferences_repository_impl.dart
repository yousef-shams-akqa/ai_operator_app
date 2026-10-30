import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';
import 'package:ai_operator_app/core/storage/app_preferences.dart';

class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  UserPreferencesRepositoryImpl(this._appPreferences);

  final AppPreferences _appPreferences;

  @override
  String? get profileName => _appPreferences.name;

  @override
  Future<void> saveProfileName(String name) async {
    await _appPreferences.setName(name);
  }

  @override
  bool get isDarkModeEnabled => _appPreferences.isDarkMode;

  @override
  Future<void> saveDarkModeEnabled(bool enabled) async {
    await _appPreferences.setDarkMode(enabled);
  }
}
