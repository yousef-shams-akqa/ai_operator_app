import 'package:ai_operator_app/core/viewmodel/app_state.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/get_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/get_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppViewModel extends Cubit<AppState> {
  AppViewModel({
    required GetProfileNameUseCase getProfileName,
    required SetProfileNameUseCase setProfileName,
    required GetDarkModeUseCase getDarkMode,
    required SetDarkModeUseCase setDarkMode,
  })  : _getProfileName = getProfileName,
        _setProfileName = setProfileName,
        _getDarkMode = getDarkMode,
        _setDarkMode = setDarkMode,
        super(const AppState(isDarkMode: false, name: ''));

  final GetProfileNameUseCase _getProfileName;
  final SetProfileNameUseCase _setProfileName;
  final GetDarkModeUseCase _getDarkMode;
  final SetDarkModeUseCase _setDarkMode;

  Future<void> initialize() async {
    final name = _getProfileName();
    final isDarkMode = _getDarkMode();
    emit(state.copyWith(name: name ?? '', isDarkMode: isDarkMode));
  }

  Future<void> setName(String name) async {
    await _setProfileName(name);
    emit(state.copyWith(name: name));
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    await _setDarkMode(isDarkMode);
    emit(state.copyWith(isDarkMode: isDarkMode));
  }
}
