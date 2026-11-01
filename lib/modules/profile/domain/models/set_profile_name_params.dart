import '../../../../../packages/flutter_ai_operator/lib/src/models/function_definition.dart';

final class SetProfileNameParams {
  const SetProfileNameParams({required this.name});

  static const jsonKey = 'name';

  final String name;

  factory SetProfileNameParams.fromJson(Map<String, dynamic> json) {
    return SetProfileNameParams(name: json[jsonKey] as String);
  }

  static FunctionParameter toFunctionParameter() {
    return const FunctionParameter(
      key: jsonKey,
      value: FunctionParameterValue(
        type: FunctionParameterType.string,
        description: 'Display name to store for the user profile.',
      ),
    );
  }
}
