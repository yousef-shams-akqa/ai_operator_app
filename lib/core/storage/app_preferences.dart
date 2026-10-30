import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Local key-value storage backed by [SharedPreferences].
class AppPreferences {
  AppPreferences(this._preferences);

  final SharedPreferences _preferences;

  static AppPreferences? _instance;

  /// Loads shared preferences and registers the app-wide instance.
  static Future<AppPreferences> initialize() async {
    _instance = AppPreferences(await SharedPreferences.getInstance());
    return _instance!;
  }

  /// The instance created by [initialize].
  static AppPreferences get instance {
    final preferences = _instance;
    if (preferences == null) {
      throw StateError('AppPreferences is not initialized. Call AppPreferences.initialize() in main().');
    }
    return preferences;
  }

  String? get name => _preferences.getString(StorageKeys.name);

  Future<bool> setName(String value) {
    return _preferences.setString(StorageKeys.name, value);
  }

  Future<bool> clearName() {
    return _preferences.remove(StorageKeys.name);
  }

  bool get isDarkMode => _preferences.getBool(StorageKeys.darkMode) ?? false;


  Future<bool> setDarkMode(bool value) {
    return _preferences.setBool(StorageKeys.darkMode, value);
  }
}


class StorageKeys {
  static const name = 'name';
  static const darkMode = 'dark_mode';
}