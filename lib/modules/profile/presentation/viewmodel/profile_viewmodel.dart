import 'dart:async';

import 'package:ai_operator_app/modules/profile/domain/models/set_profile_name_params.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/watch_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/presentation/viewmodel/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel({
    required WatchProfileNameUseCase watchProfileName,
    required SetProfileNameUseCase setProfileName,
  })  : _watchProfileName = watchProfileName,
        _setProfileName = setProfileName,
        super(ProfileInitial()) {
    _profileNameSubscription =
        _watchProfileName.call().listen(_onProfileNameChanged);
  }

  final WatchProfileNameUseCase _watchProfileName;
  final SetProfileNameUseCase _setProfileName;
  StreamSubscription<String?>? _profileNameSubscription;

  void _onProfileNameChanged(String? name) {
    if (isClosed) {
      return;
    }
    emit(ProfileLoaded(name: name ?? ''));
  }

  Future<void> setName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return;
    }
    emit(ProfileLoading(name: state.name));
    final result = await _setProfileName.execute(
      SetProfileNameParams(name: trimmed),
    );
    result.fold(
      (failure) => emit(ProfileError(name: state.name, error: failure)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _profileNameSubscription?.cancel();
    return super.close();
  }
}
