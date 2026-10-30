import 'package:shared_preferences/shared_preferences.dart';

/// Local key-value storage backed by [SharedPreferences].
class AppPreferences {
  static late final SharedPreferences _preferences;

  static AppPreferences? instance;

  AppPreferences._();

  factory AppPreferences() {
    return instance ?? AppPreferences._();
  }

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? get name => _preferences.getString(AppPreferencesKeys.name);

  Future<bool> setName(String value) {
    return _preferences.setString(AppPreferencesKeys.name, value);
  }

  Future<bool> clearName() {
    return _preferences.remove(AppPreferencesKeys.name);
  }

  bool get isDarkMode => _preferences.getBool(AppPreferencesKeys.darkMode) ?? false;


  Future<bool> setDarkMode(bool value) {
    return _preferences.setBool(AppPreferencesKeys.darkMode, value);
  }
}


class AppPreferencesKeys {
  static const name = 'name';
  static const darkMode = 'dark_mode';
}