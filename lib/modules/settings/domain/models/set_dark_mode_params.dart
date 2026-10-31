import 'package:ai_operator_app/core/ai/models/function_definition.dart';

final class SetDarkModeParams {
  const SetDarkModeParams({required this.enabled});

  static const jsonKey = 'enabled';

  final bool enabled;

  factory SetDarkModeParams.fromJson(Map<String, dynamic> json) {
    return SetDarkModeParams(enabled: json[jsonKey] as bool);
  }

  static FunctionParameter toFunctionParameter() {
    return const FunctionParameter(
      key: jsonKey,
      value: FunctionParameterValue(
        type: FunctionParameterType.boolean,
        description: 'True to enable dark mode, false for light mode.',
      ),
    );
  }
}
