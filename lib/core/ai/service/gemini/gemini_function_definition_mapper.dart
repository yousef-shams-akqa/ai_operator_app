import 'package:ai_operator_app/core/ai/models/function_definition.dart';
import 'package:ai_operator_app/core/ai/interfaces/function_definition_mapper.dart';
import 'package:firebase_ai/firebase_ai.dart';

/// Maps app-level [FunctionDefinition] to Firebase AI [FunctionDeclaration].
class GeminiFunctionDefinitionMapper implements FunctionDefinitionMapper<Tool> {
  const GeminiFunctionDefinitionMapper();

  @override
  List<Tool> toolsFromDefinitions(
    List<FunctionDefinition> definitions,
  ) {
    if (definitions.isEmpty) {
      return const [];
    }

    return [
      Tool.functionDeclarations(
        definitions.map(_toGeminiFunctionDefinition).toList(),
      ),
    ];
  }

  Schema _schemaFromParameterValue(FunctionParameterValue value) {
    switch (value.type) {
      case FunctionParameterType.string:
        if (value.possibleValues.isNotEmpty) {
          return Schema.enumString(
            enumValues: value.possibleValues,
            description: value.description,
          );
        }
        return Schema.string(description: value.description);
      case FunctionParameterType.number:
        return Schema.number(description: value.description);
      case FunctionParameterType.integer:
        return Schema.integer(description: value.description);
      case FunctionParameterType.boolean:
        return Schema.boolean(description: value.description);
    }
  }

    FunctionDeclaration _toGeminiFunctionDefinition(FunctionDefinition definition) {
      final parameters = {
        for (final parameter in definition.parameters)
          parameter.key: _schemaFromParameterValue(parameter.value),
      };

      return FunctionDeclaration(
        definition.name,
        definition.description,
        parameters: parameters,
        optionalParameters: definition.optionalParameters,
      );
  }
}
