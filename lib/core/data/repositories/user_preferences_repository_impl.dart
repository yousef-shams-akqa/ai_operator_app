import 'dart:async';

import 'package:ai_operator_app/core/domain/repositories/user_preferences_repository.dart';
import 'package:ai_operator_app/core/storage/app_preferences.dart';

class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  UserPreferencesRepositoryImpl(this._appPreferences);

  final AppPreferences _appPreferences;
  final StreamController<String?> _profileNameUpdates =
      StreamController<String?>.broadcast();
  final StreamController<bool> _darkModeUpdates =
      StreamController<bool>.broadcast();

  @override
  String? get profileName => _appPreferences.name;

  @override
  Stream<String?> watchProfileName() async* {
    yield _appPreferences.name;
    yield* _profileNameUpdates.stream;
  }

  @override
  Future<void> saveProfileName(String name) async {
    await _appPreferences.setName(name);
    _profileNameUpdates.add(name);
  }

  @override
  bool get isDarkModeEnabled => _appPreferences.isDarkMode;

  @override
  Stream<bool> watchDarkModeEnabled() async* {
    yield _appPreferences.isDarkMode;
    yield* _darkModeUpdates.stream;
  }

  @override
  Future<void> saveDarkModeEnabled(bool enabled) async {
    await _appPreferences.setDarkMode(enabled);
    _darkModeUpdates.add(enabled);
  }
}
