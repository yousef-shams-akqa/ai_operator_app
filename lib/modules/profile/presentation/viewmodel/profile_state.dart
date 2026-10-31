sealed class ProfileState {
  final String name;

  ProfileState({required this.name});
}

class ProfileInitial extends ProfileState {
  ProfileInitial({super.name = ''});
}

class ProfileLoading extends ProfileState {
  ProfileLoading({required super.name});
}

class ProfileLoaded extends ProfileState {
  ProfileLoaded({required super.name});
}

class ProfileError extends ProfileState {
  final Error error;

  ProfileError({required super.name, required this.error});
}
