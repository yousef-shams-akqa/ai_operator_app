/// JSON Schema–style parameter types supported for Gemini function calling.
enum FunctionParameterType {
  string,
  number,
  integer,
  boolean,
}

/// Describes a function the model may call, aligned with Gemini function calling.
class FunctionDeclaration {
  const FunctionDeclaration({
    required this.name,
    required this.description,
    this.parameters = const {},
    this.optionalParameters = const [],
  });

  final String name;
  final String description;

  /// Parameter names mapped to their JSON Schema type.
  final Map<String, FunctionParameterType> parameters;

  /// Names of parameters that are not required.
  final List<String> optionalParameters;

  FunctionDeclaration copyWith({
    String? name,
    String? description,
    Map<String, FunctionParameterType>? parameters,
    List<String>? optionalParameters,
  }) {
    return FunctionDeclaration(
      name: name ?? this.name,
      description: description ?? this.description,
      parameters: parameters ?? this.parameters,
      optionalParameters: optionalParameters ?? this.optionalParameters,
    );
  }
}
