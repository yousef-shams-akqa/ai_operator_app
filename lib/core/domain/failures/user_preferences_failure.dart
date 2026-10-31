class UserPreferencesFailure extends Error {
  UserPreferencesFailure(this.message, [this.cause, this.stackTrace]);

  final String message;
  final Object? cause;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() => 'UserPreferencesFailure: $message';
}
