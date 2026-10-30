class AppState {
  final bool isDarkMode;
  final String name;

  const AppState({required this.isDarkMode, required this.name});

  AppState copyWith({bool? isDarkMode, String? name}) {
    return AppState(isDarkMode: isDarkMode ?? this.isDarkMode, name: name ?? this.name);
  }
}