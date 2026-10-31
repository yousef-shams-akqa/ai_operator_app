sealed class SettingsState {
  final bool isDarkModeEnabled;

  SettingsState({required this.isDarkModeEnabled});
}

class SettingsInitial extends SettingsState {
  SettingsInitial({super.isDarkModeEnabled = false});
}

class SettingsLoading extends SettingsState {
  SettingsLoading({required super.isDarkModeEnabled});
}

class SettingsLoaded extends SettingsState {
  SettingsLoaded({required super.isDarkModeEnabled});
}

class SettingsError extends SettingsState {
  final Error error;

  SettingsError({required super.isDarkModeEnabled, required this.error});
}
