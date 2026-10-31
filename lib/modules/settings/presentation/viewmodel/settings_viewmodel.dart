import 'package:ai_operator_app/core/domain/models/no_params.dart';
import 'package:ai_operator_app/modules/settings/domain/models/set_dark_mode_params.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/get_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/presentation/viewmodel/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsViewModel extends Cubit<SettingsState> {
  SettingsViewModel({
    required GetDarkModeUseCase getDarkMode,
    required SetDarkModeUseCase setDarkMode,
  })  : _getDarkMode = getDarkMode,
        _setDarkMode = setDarkMode,
        super(SettingsInitial());

  final GetDarkModeUseCase _getDarkMode;
  final SetDarkModeUseCase _setDarkMode;

  Future<void> load() async {
    emit(SettingsLoading(isDarkModeEnabled: state.isDarkModeEnabled));
    final result = await _getDarkMode.execute(NoParams());
    result.fold(
      (failure) => emit(
        SettingsError(isDarkModeEnabled: state.isDarkModeEnabled, error: failure),
      ),
      (output) => emit(SettingsLoaded(isDarkModeEnabled: output.enabled)),
    );
  }

  Future<void> setDarkMode(bool enabled) async {
    emit(SettingsLoading(isDarkModeEnabled: state.isDarkModeEnabled));
    final result = await _setDarkMode.execute(SetDarkModeParams(enabled: enabled));
    result.fold(
      (failure) => emit(
        SettingsError(isDarkModeEnabled: state.isDarkModeEnabled, error: failure),
      ),
      (_) => emit(SettingsLoaded(isDarkModeEnabled: enabled)),
    );
  }
}
