class NavigationFailure extends Error {
  NavigationFailure(this.message, [this.cause, this.stackTrace]);

  final String message;
  final Object? cause;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() => 'NavigationFailure: $message';
}
