import 'dart:async';

import 'package:ai_operator_app/modules/settings/domain/models/set_dark_mode_params.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/set_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/domain/usecases/watch_dark_mode_usecase.dart';
import 'package:ai_operator_app/modules/settings/presentation/viewmodel/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsViewModel extends Cubit<SettingsState> {
  SettingsViewModel({
    required WatchDarkModeUseCase watchDarkMode,
    required SetDarkModeUseCase setDarkMode,
  })  : _watchDarkMode = watchDarkMode,
        _setDarkMode = setDarkMode,
        super(SettingsInitial()) {
    _darkModeSubscription = _watchDarkMode.call().listen(_onDarkModeChanged);
  }

  final WatchDarkModeUseCase _watchDarkMode;
  final SetDarkModeUseCase _setDarkMode;
  StreamSubscription<bool>? _darkModeSubscription;

  void _onDarkModeChanged(bool enabled) {
    if (isClosed) {
      return;
    }
    emit(SettingsLoaded(isDarkModeEnabled: enabled));
  }

  Future<void> setDarkMode(bool enabled) async {
    emit(SettingsLoading(isDarkModeEnabled: state.isDarkModeEnabled));
    final result = await _setDarkMode.execute(SetDarkModeParams(enabled: enabled));
    result.fold(
      (failure) => emit(
        SettingsError(isDarkModeEnabled: state.isDarkModeEnabled, error: failure),
      ),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _darkModeSubscription?.cancel();
    return super.close();
  }
}
