/// Persistence for profile and app settings preferences.
abstract interface class UserPreferencesRepository {
  String? get profileName;

  Future<void> saveProfileName(String name);

  bool get isDarkModeEnabled;

  Future<void> saveDarkModeEnabled(bool enabled);
}
