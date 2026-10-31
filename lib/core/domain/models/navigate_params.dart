/// Input for [NavigateUseCase]: where to go (or pop) and how.
final class NavigateParams {
  NavigateParams({
    this.location,
    this.push = false,
    this.replace = false,
    this.pop = false,
    this.popResult,
    this.queryParameters,
    this.pathParameters,
    this.extra,
  }) :         assert(
          pop || location != null,
          'Provide location unless pop is true',
        ),
        assert(
          !push || !replace,
          'Use either push or replace, not both',
        ),
        assert(
          !pop || location == null,
          'Do not set location when pop is true',
        );

  /// Route path (e.g. [AppRoutes.home]). Required unless [pop] is true.
  final String? location;

  /// Uses [GoRouter.push] instead of [GoRouter.go].
  final bool push;

  /// Uses [GoRouter.replace] instead of [GoRouter.go].
  final bool replace;

  /// Pops the current route via [GoRouter.pop].
  final bool pop;

  final Object? popResult;

  final Map<String, String>? queryParameters;

  final Map<String, String>? pathParameters;

  final Object? extra;

  factory NavigateParams.fromJson(Map<String, dynamic> json) {
    final pop = json['pop'] as bool? ?? false;
    if (pop) {
      return NavigateParams(
        pop: true,
        popResult: json['popResult'],
      );
    }

    return NavigateParams(
      location: json['location'] as String?,
      push: json['push'] as bool? ?? false,
      replace: json['replace'] as bool? ?? false,
      popResult: json['popResult'],
      queryParameters: _stringMap(json['queryParameters']),
      pathParameters: _stringMap(json['pathParameters']),
      extra: json['extra'],
    );
  }

  static Map<String, String>? _stringMap(Object? value) {
    if (value is! Map) {
      return null;
    }
    return value.map(
      (key, dynamic entry) => MapEntry(key.toString(), entry.toString()),
    );
  }

  NavigateParams copyWith({
    String? location,
    bool? push,
    bool? replace,
    bool? pop,
    Object? popResult,
    Map<String, String>? queryParameters,
    Map<String, String>? pathParameters,
    Object? extra,
  }) {
    return NavigateParams(
      location: location ?? this.location,
      push: push ?? this.push,
      replace: replace ?? this.replace,
      pop: pop ?? this.pop,
      popResult: popResult ?? this.popResult,
      queryParameters: queryParameters ?? this.queryParameters,
      pathParameters: pathParameters ?? this.pathParameters,
      extra: extra ?? this.extra,
    );
  }

  Map<String, dynamic> toJson() {
    if (pop) {
      return {
        'pop': true,
        if (popResult != null) 'popResult': popResult,
      };
    }

    return {
      if (location != null) 'location': location,
      if (push) 'push': push,
      if (replace) 'replace': replace,
      if (popResult != null) 'popResult': popResult,
      if (queryParameters != null) 'queryParameters': queryParameters,
      if (pathParameters != null) 'pathParameters': pathParameters,
      if (extra != null) 'extra': extra,
    };
  }
}
