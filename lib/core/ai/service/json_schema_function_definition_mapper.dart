import 'package:ai_operator_app/core/ai/models/function_definition.dart';
import 'package:ai_operator_app/core/ai/interfaces/function_definition_mapper.dart';

/// Maps app definitions to a provider-neutral JSON function representation.
class JsonSchemaFunctionDefinitionMapper implements FunctionDefinitionMapper<Map<String, dynamic>> {
  const JsonSchemaFunctionDefinitionMapper();

  @override
  List<Map<String, dynamic>> toolsFromDefinitions(
    List<FunctionDefinition> definitions,
  ) {
    return definitions.map(_toJsonFunctionDefinition).toList();
  }

  Map<String, dynamic> _toJsonFunctionDefinition(
    FunctionDefinition definition,
  ) {
    return {
      'name': definition.name,
      'description': definition.description,
      'parameters': _parametersSchema(definition),
    };
  }

  Map<String, dynamic> _parametersSchema(FunctionDefinition definition) {
    final properties = <String, dynamic>{
      for (final parameter in definition.parameters)
        parameter.key: _schemaFor(parameter.value),
    };
    final required = definition.parameters
        .where(
          (parameter) => !definition.optionalParameters.contains(parameter.key),
        )
        .map((parameter) => parameter.key)
        .toList();

    return {
      'type': 'object',
      'properties': properties,
      if (required.isNotEmpty) 'required': required,
    };
  }

  Map<String, dynamic> _schemaFor(FunctionParameterValue parameter) {
    final type = switch (parameter.type) {
      FunctionParameterType.string => 'string',
      FunctionParameterType.number => 'number',
      FunctionParameterType.integer => 'integer',
      FunctionParameterType.boolean => 'boolean',
    };
    return {
      'type': type,
      'description': parameter.description,
      if (parameter.possibleValues.isNotEmpty) 'enum': parameter.possibleValues,
    };
  }
}
