import 'package:ai_operator_app/core/domain/models/no_params.dart';
import 'package:ai_operator_app/modules/profile/domain/models/set_profile_name_params.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/get_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/domain/usecases/set_profile_name_usecase.dart';
import 'package:ai_operator_app/modules/profile/presentation/viewmodel/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel({
    required GetProfileNameUseCase getProfileName,
    required SetProfileNameUseCase setProfileName,
  })  : _getProfileName = getProfileName,
        _setProfileName = setProfileName,
        super(ProfileInitial());

  final GetProfileNameUseCase _getProfileName;
  final SetProfileNameUseCase _setProfileName;

  Future<void> load() async {
    emit(ProfileLoading(name: state.name));
    final result = await _getProfileName.execute(NoParams());
    result.fold(
      (failure) => emit(ProfileError(name: state.name, error: failure)),
      (output) => emit(ProfileLoaded(name: output.value ?? '')),
    );
  }

  Future<void> setName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) { return; }
    emit(ProfileLoading(name: state.name));
    final result = await _setProfileName.execute(
      SetProfileNameParams(name: trimmed),
    );
    result.fold(
      (failure) => emit(ProfileError(name: state.name, error: failure)),
      (_) => emit(ProfileLoaded(name: trimmed)),
    );
  }
}
