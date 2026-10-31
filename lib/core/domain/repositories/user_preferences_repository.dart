/// Persistence for profile and app settings preferences.
abstract interface class UserPreferencesRepository {
  String? get profileName;

  /// Emits the current name, then each value saved through [saveProfileName].
  Stream<String?> watchProfileName();

  Future<void> saveProfileName(String name);

  bool get isDarkModeEnabled;

  /// Emits the current value, then each value saved through [saveDarkModeEnabled].
  Stream<bool> watchDarkModeEnabled();

  Future<void> saveDarkModeEnabled(bool enabled);
}
